class PaymentPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    return false unless user.present?
    user.admin? || record.student_id == user.id || record.teacher_id == user.id
  end

  def create?
    return false unless user.present?
    user.student? && !record.course.nil? && record.course.available?
  end

  def receipt?
    show?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.teacher?
        scope.where(teacher_id: user.id)
      else
        scope.where(student_id: user.id)
      end
    end
  end

  private

  def payment
    record
  end
end
