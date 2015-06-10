class Example::TestsController < ApplicationController
  before_action :set_example_test, only: [:show, :edit, :update, :destroy]

  # GET /example/tests
  # GET /example/tests.json
  def index
    @example_tests = Example::Test.all
  end

  # GET /example/tests/1
  # GET /example/tests/1.json
  def show
  end

  # GET /example/tests/new
  def new
    @example_test = Example::Test.new
  end

  # GET /example/tests/1/edit
  def edit
  end

  # POST /example/tests
  # POST /example/tests.json
  def create
    @example_test = Example::Test.new(example_test_params)

    respond_to do |format|
      if @example_test.save
        format.html { redirect_to @example_test, notice: 'Test was successfully created.' }
        format.json { render action: 'show', status: :created, location: @example_test }
      else
        format.html { render action: 'new' }
        format.json { render json: @example_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /example/tests/1
  # PATCH/PUT /example/tests/1.json
  def update
    respond_to do |format|
      if @example_test.update(example_test_params)
        format.html { redirect_to @example_test, notice: 'Test was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @example_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /example/tests/1
  # DELETE /example/tests/1.json
  def destroy
    @example_test.destroy
    respond_to do |format|
      format.html { redirect_to example_tests_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_example_test
      @example_test = Example::Test.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def example_test_params
      params.require(:example_test).permit(:name)
    end
end
