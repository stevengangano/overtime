class StaticController < ApplicationController
	def homepage
		if current_user.type == 'AdminUser'
			@pending_approvals = Post.submitted
			#or @pending_approvals = Post.where(status: 'submitted')
			@recent_audit_items = AuditLog.all
		else
			@pending_audit_confirmations = current_user.audit_logs
		end
	end
end