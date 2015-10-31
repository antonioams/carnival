class Admin::TodosController < Carnival::BaseAdminController
  def permitted_params
    params.permit(todo: [:title, :status, :todo_list_id])
  end
end
