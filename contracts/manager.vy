# @version ^0.3.4

# Interfaces
import vehicle as Vehicle

# Structs
struct Register:
    vehicleAddress: address
    owner: address
    vin: String[17]
    model: String[256]

# State variables
vehicleTemplate: address
vehicles: DynArray[Register, 256]

@external
def __init__(template: address):
    self.vehicleTemplate = template

@external
def add_vehicle(_owner: address, _vin: String[17], _model: String[256]):
    new_vehicle_address: address = create_minimal_proxy_to(self.vehicleTemplate)
    Vehicle(new_vehicle_address).setup(self, _owner, _vin, _model)
    self.vehicles.append(Register({vehicleAddress: new_vehicle_address, owner: _owner, vin: _vin, model: _model}))

@external
@view
def search_vin(vin: String[17]) -> address:
    assert len(vin) == 17, "The vin must have 17 characters"

    for register in self.vehicles:
        if register.vin == vin:
            return register.vehicleAddress

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
            _addresses.append(register.vehicleAddress)
            _owners.append(register.owner)
            _vins.append(register.vin)
            _models.append(register.model)


    return (_addresses, _owners, _vins, _models)

@internal
def find_vehicle(_vehicle_address: address) -> Register:
    for register in self.vehicles:
        if register.vehicleAddress == _vehicle_address:
            return register

    return empty(Register)

@external
def transfer(_newOwner: address, _vehicle_address: address):
    _vehicle_register: Register = self.find_vehicle(_vehicle_address)

    assert _vehicle_register.owner == msg.sender, "Only the owner can transfer the vehicle"

    Vehicle(_vehicle_address).transfer_to(_newOwner)
