# @version ^0.3.4

# Interfaces
import vehicle as Vehicle

# Structs
struct Register:
    vehicle_address: address
    owner: address
    vin: String[17]
    model: String[256]

# State variables
vehicle_template: address
vehicles: DynArray[Register, 256]
vehicles_by_address: HashMap[address, uint256]
vehicles_by_vin: HashMap[String[17], uint256]
new_vehicle_index: uint256

@external
def __init__(template: address):
    self.vehicle_template = template
    self.new_vehicle_index = 0

@external
def add_vehicle(_owner: address, _vin: String[17], _model: String[256]):
    new_vehicle_address: address = create_minimal_proxy_to(self.vehicle_template)
    Vehicle(new_vehicle_address).setup(self, _owner, _vin, _model)
    self.vehicles.append(Register({vehicle_address: new_vehicle_address, owner: _owner, vin: _vin, model: _model}))
    self.vehicles_by_address[new_vehicle_address] = self.new_vehicle_index
    self.vehicles_by_vin[_vin] = self.new_vehicle_index
    self.new_vehicle_index += 1

@external
@view
def search_vin(vin: String[17]) -> address:
    assert len(vin) == 17, "The vin must have 17 characters"

    _vehicle_index: uint256 = self.vehicles_by_vin[vin]

    if (self.vehicles[_vehicle_index].vin == vin):
        return self.vehicles[_vehicle_index].vehicle_address
        
    return empty(address)

@external
@view
def search_my_vehicles() -> (DynArray[address, 256], DynArray[address, 256], DynArray[String[17], 256], DynArray[String[256], 256]):
    _addresses: DynArray[address, 256] = []
    _owners: DynArray[address, 256] = []
    _vins: DynArray[String[17], 256] = []
    _models: DynArray[String[256], 256] = []

    for register in self.vehicles:
        if register.owner == msg.sender:
            _addresses.append(register.vehicle_address)
            _owners.append(register.owner)
            _vins.append(register.vin)
            _models.append(register.model)

    return (_addresses, _owners, _vins, _models)

@external
def transfer_vehicle(_newOwner: address, _vehicle_address: address):
    _vehicle_index: uint256 = self.vehicles_by_address[_vehicle_address]

    assert self.vehicles[_vehicle_index].owner == msg.sender, "Only the owner can transfer the vehicle"

    Vehicle(self.vehicles[_vehicle_index].vehicle_address).transfer_to(_newOwner)
    self.vehicles[_vehicle_index].owner = _newOwner
