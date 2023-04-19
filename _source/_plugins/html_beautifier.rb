require 'rubygems'
require 'htmlbeautifier'

Jekyll::Hooks.register :documents, :post_render do |page|
    next if page.output_ext != '.html'
    page.output = HtmlBeautifier.beautify(page.output) + "\n"
end

Jekyll::Hooks.register :pages, :post_render do |page|
    next if page.ext != '.html'
    page.output = HtmlBeautifier.beautify(page.output) + "\n"
end
