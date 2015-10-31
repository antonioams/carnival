Carnival.configure do |config|
  config.menu = {
    menu1: {
      label: 'Menu 1',
      link: '#',
      class: 'menu-1',
      subs: [
        {
          label: 'Sub Menu 1',
          link: '#'
        },
        {
          label: 'Sub Menu 2',
          link: '#'
        }
      ]
    },
    menu2: {
      label: 'Menu 2',
      link: '#',
      class: 'menu-2',
      subs: [
        {
          label: 'Sub Menu 1',
          link: '#'
        },
        {
          label: 'Sub Menu 2',
          link: '#'
        }
      ]
    }
  }

  # config.custom_javascript_files = %w( angular.js )
  # config.custom_css_files = %w( angular.css )
  config.use_full_model_name = false
  # config.root_action = 'admin/articles#index'
  Rails.application.config.assets.precompile += %w( carnival/* )
end
