PHANTOMJS_FILE= 'phantomjs-2.1.1-linux-x86_64'
PHANTOMJS_ZIP_FILE = PHANTOMJS_FILE + '.tar.bz2'

PHANTOMJS_DIR = '/opt/phantomjs'
PHANTOMJS_SHELL = '/etc/profile.d/phantomjs.sh'

execute 'install ' do
  not_if "test -e #{PHANTOMJS_DIR}/bin/phantomjs"
  command <<-EOL
    wget --no-check-certificate https://bitbucket.org/ariya/phantomjs/downloads/#{PHANTOMJS_ZIP_FILE}
    tar jxf #{PHANTOMJS_ZIP_FILE} -C /opt
    mv /opt/#{PHANTOMJS_FILE} #{PHANTOMJS_DIR}
    echo 'export PATH="#{PHANTOMJS_DIR}/bin:$PATH"' >> #{PHANTOMJS_SHELL}
    rm #{PHANTOMJS_ZIP_FILE}
  EOL
end
