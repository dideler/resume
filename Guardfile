guard :shell do
  watch /(.*).tex/ do |modified_files|
    `pdflatex #{modified_files[0]}`
  end
end

