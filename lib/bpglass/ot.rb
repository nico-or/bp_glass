# frozen_string_literal: true

module BPGlass
  class OT
    def self.from_excel_import(filepath)
      file = BPGlass::ExcelParser::BPGlassParser.new(filepath)
      file.ot
    end

    def self.from_bastro(filepath)
      file = BPGlass::ExcelParser::BastroParser.new(filepath)
      file.ot
    end

    attr_reader(
      :posiciones,
      :id,
      :obra,
      :fecha_despacho
    )

    def initialize(
      id:,
      obra:,
      cliente:,
      fecha_despacho:
    )
      @id = id
      @obra = obra.strip
      @cliente = cliente
      @fecha_despacho = fecha_despacho
      @posiciones = []
    end

    def cliente
      BPGlass::Clientes.alias(@cliente)
    end

    def piezas_tp
      posiciones_tp.sum(&:cantidad)
    end

    def piezas_dim
      posiciones_dim.sum(&:cantidad)
    end

    def piezas_forma
      posiciones_forma.sum(&:cantidad)
    end

    def piezas_palillaje
      posiciones_palillaje.sum(&:cantidad)
    end

    def piezas_plantilla
      posiciones_plantilla.sum(&:cantidad)
    end

    def metros_cuadrados_tp
      posiciones_tp.sum(&:metros_cuadrados)
    end

    def metros_cuadrados_dim
      posiciones_dim.sum(&:metros_cuadrados)
    end

    def metros_lineales_tp
      posiciones_tp.sum(&:metros_lineales)
    end

    def metros_lineales_dim
      posiciones_dim.sum(&:metros_lineales)
    end

    def fecha_ingreso
      Date.today.strftime('%d-%m-%Y')
    end

    def posiciones_palillaje
      posiciones.select(&:palillaje?)
    end

    def posiciones_forma
      posiciones.select(&:forma?)
    end

    def posiciones_plantilla
      posiciones.select(&:plantilla?)
    end

    def posiciones_tp
      posiciones.select(&:tp?)
    end

    def posiciones_dim
      posiciones.select(&:dim?)
    end
  end
end
