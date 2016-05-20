require File.dirname(__FILE__) + '/application_helper.rb'
application_env = ApplicationEnvironment.new('tech-news')

# RDS
DATABASE_HOST = ENV['DATABASE_HOST']
DATABASE_PORT = ENV['DATABASE_PORT']

BASH_RC = "#{ENV['APPLICATION_USER_HOME']}/.bashrc"

# アプリケーション固有の環境変数定義
execute 'init environment variables' do
  not_if "cat #{BASH_RC} | grep 'SECRET_KEY_BASE'"
  command <<-EOL
    echo 'export DATABASE_HOST="#{DATABASE_HOST}"' >> #{BASH_RC}
    echo 'export DATABASE_PORT="#{DATABASE_PORT}"' >> #{BASH_RC}

    echo 'export DATABASE_DB="#{application_env.get(:DATABASE_DB)}"' >> #{BASH_RC}
    echo 'export DATABASE_USER_NAME="#{application_env.get(:DATABASE_USER_NAME)}"' >> #{BASH_RC}
    echo 'export DATABASE_USER_PASSWORD="#{application_env.get(:DATABASE_USER_PASSWORD)}"' >> #{BASH_RC}

    echo 'export SECRET_KEY_BASE="#{application_env.get(:SECRET_KEY_BASE)}"' >> #{BASH_RC}

    echo 'export REDDIT_USER_NAME="#{application_env.get(:REDDIT_USER_NAME)}"' >> #{BASH_RC}
    echo 'export REDDIT_PASSWORD="#{application_env.get(:REDDIT_PASSWORD)}"' >> #{BASH_RC}
    echo 'export REDDIT_CLIENT_ID="#{application_env.get(:REDDIT_CLIENT_ID)}"' >> #{BASH_RC}
    echo 'export REDDIT_SECRET="#{application_env.get(:REDDIT_SECRET)}"' >> #{BASH_RC}
    source #{BASH_RC}
  EOL
end
