class ReportsController < ApplicationController
  include ApplicationHelper

  def generate_report
    @leave_types     = LeaveType.where(id: LeaveAllotment.by_company(current_user.company_id).where(role_id: [0, current_user.role_id]).pluck(:leave_type_id).uniq)
    @year_list       = (Date.today.year).downto(Date.today.year - 2).to_a
  end

  def emp_leave_report
    authorize! :emp_leave_report, :reports
    leave_type = params.has_key?(:all_leave_type) ? "" : params[:leave_type_id]

    if params["report_type"] == "emp_leave_request_details"
      get_date_range
      get_status

      report = Reports::GeneralLeaveReport.new(current_user.company_id, current_user.id, [0, current_user.role_id], leave_type, @start_date, @end_date, @leave_status)
      @leave_details = report.present
      @locals = { start_date: @start_date, end_date: @end_date, status: @status }
      xls_content("app/views/reports/emp_leave_report.xls.erb",
                  { worksheet_name: "leave report",
                    column_width: [200, 170, 140, 140, 140, 140, 140, 140],
                    titles: ["Leave Details Report", "#{@status}", "From: #{@start_date} To: #{@end_date}"],
                    header: @leave_details[0],
                    data: @leave_details[1] })

    else
      report = Reports::LeaveBalanceReport.new(current_user.company_id, current_user.id, [0, current_user.role_id], leave_type, params[:month], params[:year])
      @leave_balances = report.present
      @locals = {}
      xls_content("app/views/reports/emp_leave_report.xls.erb",
                  { worksheet_name: "leave balance report",
                    column_width: [200, 170, 140, 140,140, 140],
                    titles: ["Leave Balance Report", "#{params[:month]} #{params[:year]}"],
                    header: @leave_balances[0],
                    data: @leave_balances[1] })
    end
    respond_to do |format|
      format.html { render template: "/reports/emp_leave_report.html"}
      format.pdf  { render pdf: "emp_leave_report", template: "/reports/emp_leave_report.html",
          header: {html: { template: '/reports/emp_leave_report_header.html.erb', locals: @locals } } }
      format.xls  { render template: "/reports/emp_leave_report.xls.erb", layout: false, disposition: 'attachment' }
    end

  end

  def emp_leave_report_by_boss
    authorize! :emp_leave_report_by_boss, :reports

    get_users
    get_leave_type
    if params["report_type"] == "emp_leave_request_details"
      get_date_range
      get_status
Rails.logger.info "#####################"
      report = Reports::EmployeeLeaveReport.new(current_user.company_id, current_user.id, @leave_type, @start_date, @end_date, @leave_status, @user_id)
      @emp_leave_report = report.present
      @locals = { start_date: @start_date, end_date: @end_date, status: @status }

      xls_content("app/views/reports/emp_leave_report_by_boss.xls.erb",
                  { worksheet_name: "emp leave report",
                    column_width: [200, 170, 140, 140, 140, 140, 140, 140],
                    titles: ["Leave Details Report", "#{@status}", "From: #{@start_date} To: #{@end_date}"],
                    header: @emp_leave_report[0],
                    data: @emp_leave_report[1] })

      xls_content("app/views/reports/emp_leave_report_by_boss.xlsx.erb",
                  { worksheet_name: "emp leave report",
          column_width: [200, 170, 140, 140, 140, 140, 140, 140],
          titles: ["Leave Details Report", "#{@status}", "From: #{@start_date} To: #{@end_date}"],
          header: @emp_leave_report[0],
          data: @emp_leave_report[1] })

      xls_content("app/views/reports/emp_leave_report_by_boss.csv.erb",
                  { worksheet_name: "emp leave report",
          column_width: [200, 170, 140, 140, 140, 140, 140, 140],
          titles: ["Leave Details Report", "#{@status}", "From: #{@start_date} To: #{@end_date}"],
          header: @emp_leave_report[0],
          data: @emp_leave_report[1] })

    else
      report = Reports::EmployeeLeaveBalanceReport.new(current_user.company_id, current_user.id, @leave_type, params[:month], params[:year], @user_id)
      @emp_leave_report = report.present
      @locals = { }
      xls_content("app/views/reports/emp_leave_report_by_boss.xls.erb",
                  { worksheet_name: "emp leave bal report",
                    column_width: [200, 170, 140, 140,140, 140, 140],
                    titles: ["Employee Leave Balance Report", @user_name, "#{params[:month]} #{params[:year]}"],
                    header: @emp_leave_report[0],
                    data: @emp_leave_report[1] })
    end

    respond_to do |format|
      format.html { render template: "/reports/emp_leave_report_by_boss.html"}
      format.pdf  { render pdf: "emp_leave_report_by_boss", template: "/reports/emp_leave_report_by_boss.html",
          header: {html: { template: '/reports/emp_leave_report_by_boss_header.html.erb',
          locals: @locals } } }
      format.xls  { render template: "/reports/emp_leave_report_by_boss.xls.erb", layout: false, disposition: 'attachment' }
      format.xlsx  { render template: "/reports/emp_leave_report_by_boss.xlsx.erb", layout: false, disposition: 'attachment' }
      #format.csv  { render template: "/reports/emp_leave_report_by_boss.csv.erb", layout: false, disposition: 'attachment' }
      format.csv { send_data to_csv }
    end

  end

  def to_csv
    CSV.generate({}) do |csv|
      csv << @emp_leave_report[0]
      @emp_leave_report[1].each do |data|
        csv << data
      end
    end
  end

  def emp_leave_report_by_admin

    authorize! :emp_leave_report_by_admin, :reports
    get_users
    get_leave_type

    if params["report_type"] == "emp_leave_request_details"
      get_date_range
      get_status

      report = Reports::AllEmpLeaveReport.new(current_user.company_id, @leave_type, @start_date, @end_date, @leave_status, @user_id )
      @all_emp_leave_report = report.present
      @locals = { start_date: @start_date, end_date: @end_date, status: @status }

      xls_content("app/views/reports/emp_leave_report_by_admin.xls.erb",
                  { worksheet_name: "emp leave report",
                    column_width: [200, 170, 140, 140, 140, 140, 140, 140, 110],
                    titles: ["Leave Details Report", "#{@status}", "From: #{@start_date} To: #{@end_date}"],
                    header: @all_emp_leave_report[0],
                    data: @all_emp_leave_report[1] })
    elsif params["report_type"] == "leave_forwarding_details"
      report = Reports::AllEmpLeaveForwardingReport.new(current_user.company_id, @leave_type, params[:year], @user_id )
      @all_emp_leave_forwarding_report = report.present
      @locals = { }

      xls_content("app/views/reports/emp_leave_report_by_admin.xls.erb",
                  { worksheet_name: "leave forwarding",
          column_width: [200, 170, 100, 100],
          titles: ["Employee Leave Forwarding Report", @user_name, params[:year]],
          header: @all_emp_leave_forwarding_report[0],
          data: @all_emp_leave_forwarding_report[1] })
    else
      report = Reports::AllEmpLeaveBalanceReport.new(current_user.company_id, @leave_type, params[:month], params[:year], @user_id)
      @all_emp_leave_balance_report = report.present
      @locals = {}
      xls_content("app/views/reports/emp_leave_report_by_admin.xls.erb",
                  { worksheet_name: "emp leave balance",
                    column_width: [200, 170, 140, 140,140, 140, 140],
                    titles: ["Employee Leave Balance Report", @user_name, "#{params[:month]} #{params[:year]}"],
                    header: @all_emp_leave_balance_report[0],
                    data: @all_emp_leave_balance_report[1] })
    end

    respond_to do |format|
      format.html { render template: "/reports/emp_leave_report_by_admin.html"}
      format.pdf  { render pdf: "emp_leave_report_by_admin", template: "/reports/emp_leave_report_by_admin.html",
          header: {html: { template: '/reports/emp_leave_report_by_admin_header.html.erb',
          locals: @locals } } }
      format.xls  { render template: "/reports/emp_leave_report_by_admin.xls.erb", layout: false, disposition: 'attachment' }
    end
  end

  ##################
  private
  #################

  def get_date_range
    @start_date   = params[:daterange ] == "" ? Date.today : params[:daterange].split(" - ").first
    @end_date     = params[:daterange ] == "" ? Date.today.end_of_month : params[:daterange].split(" - ").last
  end

  def get_users
    params[:emp_id] = current_user.id if !params.has_key?(:all_emp) && params[:emp_id].blank?
    @user_id     = !params.has_key?(:all_emp) ? User.find(params[:emp_id]) : (params.has_key?(:all_emp) && params.has_key?(:is_boss) ? (User.by_boss(current_user.id).pluck(:id)) : User.by_company(current_user.company_id).pluck(:id))
    @user_name   = params.has_key?(:all_emp) ? "All Employee" : @user_id.get_full_detail
  end

  def get_status
    status        = params[:status] == "" ? ["Pending", nil] : (params[:status] == "1" ? ["Aproved", true] : ["Rejected", false])
    @leave_status = params.has_key?(:all_status) ? [nil, true, false] : status[1]
    @status       = params.has_key?(:all_status) ? "All Status" : status[0]
  end

  def get_leave_type
    @leave_type      = params.has_key?(:all_leave_type) ? LeaveType.by_company(current_user.company_id).pluck(:id) : params[:leave_type_id]
    @leave_type_name = params.has_key?(:all_leave_type) ? "All Leave Type" : LeaveType.by_company(current_user.company_id).where(id: params[:leave_type_id]).name
  end

end

