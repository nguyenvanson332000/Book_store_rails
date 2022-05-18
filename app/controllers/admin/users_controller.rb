class Admin::UsersController < Admin::AdminController
  before_action :load_user, :check_banner, only: :update
  before_action :check_search_book, only: :index

  def index
    @u = User.ransack(params[:q])
    @users = @u.result(distinct: true).order_by_name.page(params[:page]).per(Settings.paginate_size)
  end

  def update
    value = params[:type] == Settings.banner.unlock ? nil : Time.zone.now
    flash[:success] = t "flash.process_success"
    respond_to do |format|
      if @user.update_columns locked_at: value
        format.json { render json: {user_id: @user.id, status: :created,flash: flash.to_hash} }

      else
        format.html { render js: "window.location='#{admin_users_path}'" }
      end
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    respond_to do |format|
      format.html { render js: "window.location='#{admin_users_path}'" }
    end
  end

  def check_banner
    if @user.locked_at && params[:type] == Settings.banner.lock ||
       !@user.locked_at && params[:type] == Settings.banner.unlock
      respond_to do |format|
        format.html { render js: "window.location='#{admin_users_path}'" }
      end
    end
  end
end
