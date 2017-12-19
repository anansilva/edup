class ContentsController < ApplicationController
  before_action :set_course, only: [:index, :new, :create]

  def index
    set_course
    @contents = @course.contents
    @students = @course.students
  end

  def new
    @publisher = current_publisher
    set_course
    @content = Content.new
  end

  def create
    set_course
    @content = Content.new(content_params)
    @content.save
    @course_content = CourseContent.new
    @course_content.course = @course
    @course_content.content_id = @content.id
     if @course_content.save
      redirect_to course_content_path(params[:publisher_id], params[:course_slug])
    else
      render :new
    end
  end

  def invite_student_new
    @student = Student.new
    @publisher = Publisher.find(params[:publisher_id])
    course
  end

  def invite_student_create
    @student = Student.new(invite_params)
    if Student.find_by(email: invite_params[:email]) == nil
      @student = Student.invite!({email: invite_params[:email]}, current_publisher) do |p|
        p.skip_invitation = true
        p.accept_invitation!
      end
    else
      @student = Student.find_by(email: invite_params[:email])
    end

    @course_student = CourseStudent.new
    @course_student.course_slug = Course.find_by slug: params[:slug]
    @course_student.student_id = @student.id
    @course_student.save

    redirect_to publisher_course_contents_path
    flash[:notice] = "User invited!"
  end

  private

  def set_course
    @course = Course.find_by(slug: params[:course_slug])
  end

  def invite_params
    params.require(:student).permit(:email)
  end

  def content_params
    params.require(:content).permit(:name, :description, :video, :video_link)
  end
end
