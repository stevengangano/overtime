class PostPolicy < ApplicationPolicy
	#This only allows creator to edit their own post
	def update?
		#Update post if admin is logged in and approves the post
		return true if admin? && post_approved?
		#Update post if post creator or admin and post is not approved
		return true if user_or_admin && !post_approved?
	end

	def approve?
		admin?
	end

	private

	#Post creator is equal to current user or admin
	def user_or_admin
		record.user.id == user.id || admin?
	end

	#Admin type is AdminUser
	def admin?
		user.type == 'AdminUser'
	end

	#Admin submitted timecard as approved
	def post_approved?
		record.approved?
	end
end
