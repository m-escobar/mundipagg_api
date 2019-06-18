class PagesController < ApplicationController
  def index
    @instructions = "Instruções de Uso"
    @functions = "Funções implementadas"
    @func1 = ""
    @func2 = ""
    @func3 = ""
  end

  def index_en
    @instructions = "Instructions"
    @functions = "Implemented Functions"
    @func1 = ""
    @func2 = ""
    @func3 = ""
  end
end
