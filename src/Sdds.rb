require 'json'
require 'matrix'
require 'pp'
require_relative 'Task.rb'

class Sdds < Task
	
	def validate_input
		# input must contain a timeseries
		# if @input['timeSeries'].empty? then @errors.push(:TIMESERIES_REQUIRED) end
		# input should contain only 1 timeseries
		# if @input['timeSeries'].length>1 then @warnings.push(:ONLY_FIRST_TIMESERIES_WILL_BE_TAKEN_INTO_ACCOUNT) end
		# timeseries must contain only binary matrixes
		#@input['timeSeries'].each do |ts|
		#	ts.data.each do |m|
		#		m['matrix'].each do |r|
		#			if r.max>1 then @errors.push(:TIMESERIES_MATRIXES_MUST_BE_BINARY) end
		#		end
		#		if !m['index'].empty? then
		#			if m['index'].length>1 then @warnings.push(:ONLY_FIRST_NODE_WILL_BE_KNOCKED_OUT) end
		#		end
		#	end
		#end
		# if a model is present, its fieldcardinity must be equal to 2
		# if !@input['models'].empty? then
		#	@input['models'].each do |k,m|
		#		if m.fieldCardinality!=2 then @errors.push(:MODELS_FIELD_CARDINALITY_MUST_BE_2) end
		#	end
		#end

		# the following arguments are required
		#required=[
		#	'numberofSimulations',
		#	'numberofTimeSteps',
		#	'initialState',
		#	'propensities'
		#]
		#required.each do |arg|
		#	if @method.arguments[arg].nil? then @errors.push(("MISSING_ARGUMENT_ERROR_"+arg.upcase).to_sym) end
		#end
	end

	def render_output(raw_output_file)
		if !File.exists?(raw_output_file) then
			puts "RAW_OUTPUT_FILE_DOES_NOT_EXISTS"
			return
		end
		raw_input = File.read(raw_output_file)
		@output=JSON.parse(raw_input)
		return @output
	end

	def run(output_file,params=nil)
		if output_file.nil? or output_file.empty? then
			puts "Error: no output file given"
			return 1
		end
		File.open("input.json",'w') { |f| f.write(JSON.dump(@input_json)) }
		system("/usr/bin/perl "+@exec_file+' -i '+'input.json'+' -o '+output_file)
		if $?.exitstatus>0 or !File.exists?(output_file) then
			return "Cannot run SDDS!"
		end
		return 1
	end

	def clean_temp_files()
		File.delete("input.json") if File.exists?("input.json")
		File.delete("output.json") if File.exists?("output.json")
	end

	def test(output_ref)
		puts "test not implemented"
	end
end

if $0 == __FILE__ then
	if !File.exists?(ARGV[0]) then puts "JSON input file not found" end
	input = File.read(ARGV[0])
	json = JSON.parse(input)
	task=Sdds.new(json,'SDDS.pl')
	asd = task.run("output.json")
	output = task.render_output("output.json")
	File.open("output.txt",'w') { |f| f.write(JSON.pretty_generate(output)) }
end
