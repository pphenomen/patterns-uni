require 'fox16'
include Fox

require_relative 'students_list_view'
require_relative 'students_list_controller'

if __FILE__ == $0
	app = FXApp.new
	view = StudentsListView.new(app, controller: nil)
	controller = StudentsListController.new(view)
	view.controller = controller  
	app.create
	app.run
end