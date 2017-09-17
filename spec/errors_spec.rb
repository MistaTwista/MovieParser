require 'errors'

describe NothingToShow do
  it do
    expect{ raise NothingToShow }.to raise_error NothingToShow
  end
end
