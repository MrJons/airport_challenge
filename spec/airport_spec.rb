require 'airport'
require 'weather'

describe Airport do

  before do
    @weather = double(:weather)
    #let(:plane) {double(:plane)}
  end

  context "#request_land" do

    it "should recognise ability to call 'request_land'" do
      expect(subject).to respond_to(:request_land)
    end

    it "landed plane should then be inside airport" do
      port = Airport.new
      plane = Plane.new
      allow(@weather).to receive(:stormy).and_return(:false)
      port.request_land(plane)
      expect(port.in_airport).to include(plane)
    end

    it "shows error when to stormy to land" do
      plane = Plane.new
      allow(subject).to receive(:stormy?).and_return(true)
      expect{subject.request_land(plane)}.to raise_error "its to dangerous to do that now"
    end

    it "raises error when airport is full" do
      allow(@weather).to receive(:stormy?).and_return(false)
      5.times {subject.request_land(Plane.new)}
      expect{subject.request_land(Plane.new)}.to raise_error "Airport full"
    end

    it "raises error when request_land is called on plane already landed" do
      plane = Plane.new
      subject.request_land(plane)
      expect(subject.request_land(plane)).to raise_error "Plane already landed"
    end
  end


  context "#request_depart" do

    it "should recognise ability to call 'request_depart'" do
      expect(subject).to respond_to(:request_depart)
    end

    it "departed plane should no longer be inside airport" do
      plane = Plane.new
      port = Airport.new
      allow(@weather).to receive(:stormy?).and_return(false)
      port.request_land(plane)
      port.request_depart(plane)
      expect(port.in_airport).not_to include(plane)
    end

    it "shows error when to stormy to take off" do
      plane = Plane.new
      subject.request_land(plane)
      allow(@weather).to receive(:stormy?).and_return(true)
      expect{subject.request_depart(plane)}.to raise_error "its to dangerous to do that now"
    end

    it "raises error when request_depart is called on plane already in flight" do
      plane = Plane.new
      expect(subject.request_depart(plane)).to raise_error "Plane already in flight"
    end
  end


  describe "capacity" do
    it "should take in custom capacity value" do
      port = Airport.new(10)
      expect(port.capacity).to eq(10)
    end
  end

end
