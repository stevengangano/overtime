class AuditLogPolicy < ApplicationPolicy
	#Override index action for Audit Log 
	def index?
		#Show Audit Log only if admin
		return true if admin?
	end

	private
	#Admin type is AdminUser
	def admin?
		user.type == 'AdminUser'
	end

end
