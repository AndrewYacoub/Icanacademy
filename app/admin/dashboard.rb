ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Welcome Message
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Overview Panels
    columns do
      column do
        panel "Recent Students" do
          ul do
            Student.order(created_at: :desc).limit(5).map do |student|
              li link_to(student.first_name + " " + student.last_name, admin_student_path(student))
            end
          end
        end
      end

      column do
        panel "Recent Teachers" do
          ul do
            Teacher.order(created_at: :desc).limit(5).map do |teacher|
              li link_to(teacher.first_name + " " + teacher.last_name, admin_teacher_path(teacher))
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Recent Courses" do
          ul do
            Course.order(created_at: :desc).limit(5).map do |course|
              li link_to(course.title, admin_course_path(course))
            end
          end
        end
      end

      column do
        panel "Recent Groups" do
          ul do
            Group.order(created_at: :desc).limit(5).map do |group|
              li link_to(group.name, admin_group_path(group))
            end
          end
        end
      end
    end

    # Statistics Panel
    columns do
      column do
        panel "Statistics" do
          div do
            "Total Students: #{Student.count}"
          end
          div do
            "Total Teachers: #{Teacher.count}"
          end
          div do
            "Total Courses: #{Course.count}"
          end
          div do
            "Total Groups: #{Group.count}"
          end
        end
      end
    end

    # Quick Actions
    section "Quick Actions" do
      div class: "quick-actions" do
        div class: "action-item" do
          link_to "New Student", new_admin_student_path, class: "button"
        end
        div class: "action-item" do
          link_to "New Teacher", new_admin_teacher_path, class: "button"
        end
        div class: "action-item" do
          link_to "New Course", new_admin_course_path, class: "button"
        end
        div class: "action-item" do
          link_to "New Group", new_admin_group_path, class: "button"
        end
      end
    end
  end
end
