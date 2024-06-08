namespace :sitemap do
  desc "Refresh sitemap without pinging search engines"
  task :refresh_no_ping do
    on roles(:app) do
      within release_path do
        execute :rake, 'sitemap:refresh:no_ping'
      end
    end
  end
end
