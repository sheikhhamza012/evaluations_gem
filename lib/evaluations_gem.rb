require "evaluations_gem/version"
require 'rubyXL'
require 'rubyXL/convenience_methods'

module EvaluationsGem
  class Error < StandardError; end
  class Evaluations
      private_class_method def self.get_uniq_managers(worksheet)
          worksheet.map do |row|
              row[1]&.value
          end&.uniq&.compact&.drop(1)
      end

      private_class_method def self.get_assendants(worksheet, manager)
          worksheet.map do |row|
              if row[1]&.value == manager && !row[1]&.value.nil?
                  row[0]&.value
              end
          end&.uniq&.compact
      end

      private_class_method def self.validate_records(worksheet)
          col_a= [] 
          col_b=[]
          manager_found=false
          error_found = false
          worksheet.each_with_index do |c,i| 

              next if i==0
              if c[0]&.value == c[1]&.value
                  worksheet.add_cell(0,2,'Comments')
                  error_found = true

                  if c[2].nil?
                      worksheet.add_cell(i,2,'identifier igual al evaluador')
                  else
                      c[2].change_contents(c[2]&.value+', identifier igual al evaluador')
                  end
              end
              worksheet.each_with_index do |row,k| 
                  next if k==0 || k==i
                  manager_found =true if row[0]&.value==c[1]&.value 
                  if row[0]&.value==c[0].value
                      error_found = true
                      worksheet.add_cell(0,2,'Comments')
                      if c[2].nil?
                          worksheet.add_cell(i,2,'usuario duplicado')
                      else
                          row[2].change_contents(row[2]&.value+', usuario duplicado')
                      end
                  end
              
              end
              if !manager_found && !c[1]&.value.nil?
                  error_found = true
                  worksheet.add_cell(0,2,'Comments')
                  if c[2].nil?
                      worksheet.add_cell(i,2,'manager_identifier no existe')
                  else
                      c[2].change_contents(c[2]&.value+', manager_identifier no existe')
                  end
              end
          end
          return error_found
      end
      private_class_method def self.duplicate(input)
          output = RubyXL::Workbook.new
          input.each_with_index do |row, i|
              output[0].add_cell(i,0,row[0]&.value)
              output[0].add_cell(i,1,row[1]&.value)
          end
          return output
      end

      # first part

      def self.manager_to_collaborator(file_path)
          input = RubyXL::Parser.parse(file_path)
          output = duplicate(input[0])
          if validate_records( output[0])
            # return output.write("evaluators_error.xlsx")
            return output

              
          end
          output = RubyXL::Workbook.new
          managers = get_uniq_managers(input[0])
          managers.each_with_index do |m, k|
              assendants = get_assendants(input[0], m) 
              output[0].add_cell(0, 0, 'identifier') 
              output[0].add_cell(k+1, 0, m) 
              assendants.each_with_index do |a, i|
                  output[0].add_cell(0, i+1, "ascendente_#{i+1}") 
                  output[0].add_cell(k+1, i+1, a) 
              end
              
          end
          output.write("output_manager.xlsx")
          return output
      end

      #2nd part 

      def self.peer_to_peer(file_path)
          input = RubyXL::Parser.parse(file_path)
          output = duplicate(input[0])
          if validate_records( output[0])
            # return output.write("evaluators_error.xlsx")
            return output

              
          end
          input[0].each_with_index do |row, i|
              next if i==0
              group = get_assendants(input[0] , row[1]&.value )
              group.delete(row[0]&.value)
              group.each_with_index do |c,k|
                  output[0].add_cell(0,k+2,"par_#{k+1}")
                  output[0].add_cell(i,k+2,c)
              end
          end
        #   output.write("output_peers.xlsx")
          return output
      end
  end
end
