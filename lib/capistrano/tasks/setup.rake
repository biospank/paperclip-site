namespace :deploy do
  desc "Create shared/tmp/tpls, shared/public/pdfs dir and link to release path"
  task :setup do
    on roles(:app) do
      with rails_env: fetch(:stage) do
        execute "mkdir -p #{shared_path}/tmp/tpls"
        execute "ln -nfs #{shared_path}/tmp/tpls #{release_path}/tmp/tpls"
        execute "mkdir -p #{shared_path}/public/pdfs"
        execute "ln -nfs #{shared_path}/public/pdfs #{release_path}/public/pdfs"
      end
    end
  end
end
