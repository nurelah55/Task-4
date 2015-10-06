class EmployeesController < ApplicationController
  def index
  	@employees = Employee.all
  end

  def new
  	@employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(params_employee)
    if @employee.save
      flash[:notice] = "Success Add Record"
      redirect_to action: 'index'
    else
      flash[:error] = "data not valid"
      render 'new'
    end
      
  end

  private
  def params_employee
  	params.require(:employee).permit(:name, :address)
  end

end
