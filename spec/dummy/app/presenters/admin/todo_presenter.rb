class Admin::TodoPresenter < Carnival::BaseAdminPresenter

  field :id, actions: [:csv, :index, :show]

  field :title,
        actions: [:csv, :index, :new, :show, :edit],
        advanced_search: { operator: :equal }

  field :status,
        actions: [:csv, :index, :new, :show, :edit],
        advanced_search: { operator: :equal },
        as: :carnival_enum

  field :created_at,
        date_filter: true, date_filter_default: :this_year,
        actions: [:csv, :index]
  field :todo_list,
        actions: [:new, :edit]

  field 'todo_list.name',
        actions: [:csv, :index, :show],
        advanced_search: { operator: :like }

  scope :todo, default: true
  scope :doing
  scope :done

  action :new
  action :show
  action :edit
  action :destroy
  action :csv
end
