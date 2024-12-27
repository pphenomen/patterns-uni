# старая система
class OldPrinter
	def print_message(message)
		puts "Сообщение: #{message}"
	end
end

# новая структура данных
class Message
	attr_reader :text, :author

	def initialize(text, author)
		@text = text
		@author = author
	end
end	

# класс наследник для адаптера
class Printer
	def print(message)
		raise NotImplementedError, "Метод должен быть реализован в адаптере"
	end
end

# адаптер
class MessagePrinterAdapter < Printer
	def initialize(old_printer)
		@old_printer = old_printer
	end

	def print(message)
		formatted_message = "#{message.text} (Автор: #{message.author})"
		@old_printer.print_message(formatted_message)
	end
end

# клиент 
class App
	def initialize(printer)
		@printer = printer
	end

	def send_message(message)
		@printer.print(message)
	end
end

old_printer = OldPrinter.new
adapter = MessagePrinterAdapter.new(old_printer)
app = App.new(adapter)

message = Message.new("Добро пожаловать", "Иван Иванов")
app.send_message(message)

# =========================================================================

class LogMessage
	attr_reader :level, :message

	def initialize(level, message)
		@level = level
		@message = message
	end
end

class OldLogger
	def log(text)
		puts "Логирование: #{text}"
	end
end

class LoggerBase
	def log_message(log_message)
		raise NotImplementedError, "Метод должен быть реализован в адаптере"
	end
end

class LoggerAdapter < LoggerBase
	def initialize(old_logger)
		@old_logger = old_logger
	end

	def log_message(log_message)
		formatted_log_msg = "[#{log_message.level}] #{log_message.message}"
		@old_logger.log(formatted_log_msg)
	end
end

class App
	def initialize(log_message)
		@log_message = log_message
	end

	def send_log_message(log_message)
		@log_message.log_message(log_message)
	end
end

old_logger = OldLogger.new
adapter = LoggerAdapter.new(old_logger)
log_message = LogMessage.new("ERROR", "Невозможно подключиться к базе данных")

adapter.log_message(log_message)

class OldPayment
	def make_payment(amount)
		puts "Оплачено #{amount}"
	end
end

class NewPayment
	def make_payment(amout)
		puts "Оплачено #{amount}"
	end
end

class PaymentAdapter
	def initialize(payment_system)
		payment_system = payment_system
	end

	def make_payment(amount)
		payment_system.make_payment(amount)
	end
end


old_system =  OldPayment.new
old_system.make_payment(500)

new_system = NewPayment.new
adapter = PaymentAdapter.new(new_system)
adapter.make_payment(200)