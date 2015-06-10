class ReportsController < ApplicationController

  def generate_report
  end

  def product_info_report
    @price = params[:price] == "" ? 0 : params[:price]
    report      = Reports::ProductReport.new(@price)
    @product_details = report.present
    respond_to do |format|
      format.html { render template: "/reports/product_info_report.html"}
      format.xls  { render template: "/reports/product_info_report.xls.erb", layout: false, disposition: 'attachment' }
    end
  end

  ########################
  private
  ########################

end

