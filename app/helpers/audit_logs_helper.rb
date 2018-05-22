module AuditLogsHelper

	def status_label status
		status_span_generator status
	end
	
	private

	def status_label status
		case status
		when 'pending'
			content_tag(:span, status.titleize, class: 'label label-primary')
		when 'confirmed'
			content_tag(:span, status.titleize, class: 'label label-success')
		end
	end
end
