describe BPGlass::OT do
  context "pedido simple" do
    let(:ot) { described_class.from_excel_import("./spec/fixtures/27153-AW-18-01-2023.xlsx") }

    describe "#id" do
      it "returns the OT number" do
        expect(ot.id).to eq("27153")
      end
    end

    describe "#cliente" do
      it "returnts the cliente alias" do
        expect(ot.cliente).to eq("RENOVATEK")
      end
    end

    describe "#obra" do
      it "returns the 'obra' name" do
        expect(ot.obra).to eq("San Eugenio. Depto. 304 URGENTE")
      end
    end

    describe "#posiciones" do
      it "has correct position count" do
        expect(ot.posiciones.count).to eq(1)
      end

      it do
        ot.posiciones.each do |posicion|
          expect(posicion.class).to eq(BPGlass::Posicion)
        end
      end
    end

    describe "#cristal_especial" do
      it do
        expect(ot.cristal_especial).to eq("SAT(1)")
      end
    end

    describe "#metros_cuadrados_tp" do
      it { expect(ot.metros_cuadrados_tp).to be_within(0.1).of(0.8) }
    end

    describe "#metros_lineales_tp" do
      it { expect(ot.metros_lineales_tp).to be_within(0.1).of(3.6) }
    end

    describe "#tp_array" do
      it "returns the correct array structure" do
        output = [
          "27153",
          "San Eugenio. Depto. 304 URGENTE",
          "SAT(1)", "",
          "RENOVATEK",
          1, "", 1, "",
          "", "", "",
          "0,8", Date.today.strftime("%d-%m-%Y"), "", "", "18-01-2023", # "area", "today", "", "", "entrega",
          "", "",
          "3,6", "", "", #"mtl tp", "", "mtl dim"
        ]

        expect(ot.tp_array).to eq(output)
      end
    end
  end

  context "pedido grande" do
    let(:ot) { described_class.from_excel_import("./spec/fixtures/27135-AW-02-02-2023.xlsx") }

    describe "#from_excel_import" do
      it { expect(ot.piezas_tp).to eq(108) }
      it { expect(ot.piezas_dim).to eq(0) }
      it { expect(ot.posiciones.count).to eq(78) }
    end

    describe "#cristal_especial" do
      it do
        output = "LAM6(31) SAT(4)"
        expect(ot.cristal_especial).to eq(output)
      end
    end
  end

  context "pedido con dimensionado" do
    let(:ot) { described_class.from_excel_import("./spec/fixtures/27138-AW-23-01-2023.xlsx") }

    describe "#tp_array" do
      it "returns 2 arrays for TP and DIM" do
        output = [
          "27138",
          "HC LOS NOGALES, CASTAÑOS, CASAS 4,52,48,46",
          "SAT(2)", "",
          "RENOVATEK",
          44, "", 44, "",
          "", "", "",
          "31,0", Date.today.strftime("%d-%m-%Y"), "", "", "23-01-2023",
          "", "",
          "159,3", "", "",
        ]
        expect(ot.tp_array).to eq(output)
      end
    end

    describe "#dim_array" do
      it do
        output = [
          "27138",
          "HC LOS NOGALES, CASTAÑOS, CASAS 4,52,48,46",
          "DIMENSIONADO", "",
          "RENOVATEK",
          "", 8, "", 8,
          "", "", "",
          "2,1", Date.today.strftime("%d-%m-%Y"), "", "", "23-01-2023",
          "", "",
          "", "", "16,5",
        ]
        expect(ot.dim_array).to eq(output)
      end
    end

    describe "#initialize" do
      it "creates the correct amount of posiciones" do
        expect(ot.posiciones.count).to eq(48)
      end
    end
  end

  context "pedido con forma" do
    let(:ot) { described_class.from_excel_import("./spec/fixtures/25766-AW-03-11-2022.xlsx") }

    describe "#posiciones" do
      it "has correct position count" do
        expect(ot.posiciones.count).to eq(7)
      end
    end

    describe "#tp_array" do
      it "returns the correct array structure" do
        output = [
          "25766",
          "RTK 5558 HC AYLEEN DUARTE",
          "CLEAR(3)", "FORMA(3)",
          "RENOVATEK",
          13, "", 13, "",
          "", "", "",
          "8,2", Date.today.strftime("%d-%m-%Y"), "", "", "03-11-2022", # "area", "today", "", "", "entrega",
          "", "",
          "37,8", "", "", #"mtl tp", "", "mtl dim"
        ]

        expect(ot.tp_array).to eq(output)
      end
    end
  end

  context "When OT has cristal-especial DIM" do
    let(:ot) { described_class.from_excel_import("./spec/fixtures/28586-AW-10-04-2023.xlsx") }

    describe "#cristal_especial" do
      it do
        expect(ot.cristal_especial).to eq("")
      end
    end
  end
  context "When OT has PALILLAJE positions" do
    let(:ot) { described_class.from_excel_import("./spec/fixtures/28665-AW-11-04-2023.xlsx") }

    describe "#palillaje" do
      it do
        expect(ot.palillaje).to eq("PALILLAJE(8)")
      end
    end

    describe "#tp_array" do
      it "returns the correct output" do
        output = [
          "28665",
          "BST 15784 PIRQUE PALILLO VEKA NEGRO SPECTRAL",
          "SAT(7)", "PALILLAJE(8)",
          "BASTRO",
          45, "", 45, "",
          "", "", "",
          "79,4", Date.today.strftime("%d-%m-%Y"), "", "", "11-04-2023", # "area", "today", "", "", "entrega",
          "", "",
          "244,7", "", "", #"mtl tp", "", "mtl dim"
        ]

        expect(ot.tp_array).to eq(output)
      end
    end
  end
end
