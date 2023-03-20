# @version ^0.3.4
# Structs
struct Maintenance:
    registered_by: address
    description: String[128]
    location: String[128]
    date: uint256

# State variables for the Vehicle contract
owner: address
vin: String[17]
maintenance_index: uint256
maintenances: DynArray[Maintenance,256]

# Events to be launched
event Transfered:
    p_owner: address
    n_owner: address

@external
def setup(_owner: address, _vin: String[17]):
    self.owner = _owner
    self.vin = _vin

@external
def register_maintenance(_description: String[128], _location: String[128], _date: uint256):
    assert msg.sender == self.owner, "Only the owner can add a maintenance record!"
    assert self.maintenance_index < 255, "The maximum ammount of maintenance records has been reached!"
    assert block.timestamp > _date, "The maintenance must be in the past!"

    self.maintenances.append(Maintenance({registered_by: msg.sender, description: _description, location: _location, date: _date})) 
    self.maintenance_index += 1

@external
def edit_maintenance(_index: uint256, _description: String[128], _location: String[128], _date: uint256):
    assert msg.sender == self.owner, "Only the owner can add a maintenance record!"
    assert self.maintenance_index >= _index, "The maintenance is out of bounds"
    assert block.timestamp > _date, "The maintenance must be in the past!"

    self.maintenances[_index].description = _description
    self.maintenances[_index].location = _location
    self.maintenances[_index].date = _date

@external
@view
def get_maintenances() -> (DynArray[address, 256], DynArray[String[128], 256], DynArray[String[128], 256], DynArray[uint256, 256]):
    _registered_by: DynArray[address, 256] = []
    _description: DynArray[String[128], 256] = []
    _location: DynArray[String[128], 256] = []
    _date: DynArray[uint256, 256] = []

    for maintenance in self.maintenances:
        _registered_by.append(maintenance.registered_by)
        _description.append(maintenance.description)
        _location.append(maintenance.location)
        _date.append(maintenance.date)

    return (_registered_by, _description, _location, _date)

@external
@view
def get_owner() -> address:
    return self.owner

@external
@view
def get_vin() -> String[17]:
    return self.vin

@external
def transfer_to(new_owner: address):
    assert msg.sender == self.owner, "Only the owner can transfer the vehicle!"

    log Transfered(self.owner, new_owner)
    self.owner = new_owner