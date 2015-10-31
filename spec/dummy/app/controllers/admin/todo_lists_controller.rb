class Admin::TodoListsController < Carnival::BaseAdminController
  def permitted_params
    params.permit(todo_list: [:name])
  end
end
