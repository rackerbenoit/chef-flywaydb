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

directory flyway['install_dir'] do
  owner flyway['user']
  group flyway['group']
  mode '0755'
end

remote_file 'download flywaydb' do
  path cache
  source flyway['url']
  checksum flyway['sha256']
  notifies :run, 'batch[unzip flyway (powershell 3 or higher required)]', :immediately if platform?('windows')
  notifies :run, 'execute[extract flyway]', :immediately unless platform?('windows')
end

if platform?('windows')
  batch 'unzip flyway (powershell 3 or higher required)' do
    code "powershell.exe -nologo -noprofile -command \"& { Add-Type -A 'System.IO.Compression.FileSystem';"\
      " [IO.Compression.ZipFile]::ExtractToDirectory('#{cache}', '#{flyway['install_dir']}'); }\""
    action :nothing
  end
else
  execute 'extract flyway' do
    command "tar -xvzf #{cache} --strip 1 && chown -R #{flyway['user']}:#{flyway['group']} ."
    cwd flyway['install_dir']
    action :nothing
  end
end
