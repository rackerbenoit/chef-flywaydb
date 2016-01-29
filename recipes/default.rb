flyway = node['flywaydb']
url = flyway['url']
cache = "#{Chef::Config[:file_cache_path]}#{url.slice(url.rindex('/'), url.size)}"

user flyway['user'] do
  comment 'Flyway System User'
  home flyway['install_dir']
  shell '/sbin/nologin'
  system true
  action [:create, :lock]
end

group flyway['group'] do
  append true
  members flyway['user']
  action :create
  only_if { flyway['user'] != flyway['group'] }
end

remote_file cache do
  source flyway['url']
  notifies :run, "batch[unzip flyway (powershell 3 or higher required)]",:immediately if platform?('windows')
  notifies :run, "execute[untar flyway]",:immediately unless platform?('windows')
end

if platform?('windows')
  # powershell version 3 or higher required
  batch 'unzip flyway (powershell 3 or higher required)' do
    code "powershell.exe -nologo -noprofile -command \"& { Add-Type -A 'System.IO.Compression.FileSystem';"\
      " [IO.Compression.ZipFile]::ExtractToDirectory('#{cache}', '#{flyway['install_dir']}'); }\""
    action :nothing
  end
else
  execute 'untar flyway' do
    command "tar -C #{flyway['install_dir']} -xvf #{cache}"
    user flyway['user']
    action :nothing
  end
end
