# @version ^0.3.4
# Structs
struct Maintenance:
    registered_by: address
    service: String[128]
    repair_shop: String[128]
    mileage: uint256
    date: uint256

# State variables for the Vehicle contract
manager: address
new_maintenance_index: uint256
maintenances: DynArray[Maintenance,256]
model: String[128]
owner: address
vin: String[17]

@external
def setup(_manager: address, _owner: address, _vin: String[17], _model: String[128]):
    self.manager = _manager
    self.model = _model
    self.owner = _owner
    self.vin = _vin

@external
def register_maintenance(_service: String[128], _repair_shop: String[128], _date: uint256, _mileage: uint256):
    assert msg.sender == self.owner, "Only the owner can add a maintenance record!"
    assert self.new_maintenance_index < 255, "The maximum ammount of maintenance records has been reached!"
    assert block.timestamp > _date, "The maintenance must be in the past!"

    self.maintenances.append(Maintenance({registered_by: msg.sender, service: _service, repair_shop: _repair_shop,  mileage: _mileage, date: _date})) 
    self.new_maintenance_index += 1

@external
def edit_maintenance(_index: uint256, _service: String[128], _repair_shop: String[128], _date: uint256, _mileage: uint256):
    assert msg.sender == self.owner, "Only the owner can edit a maintenance record!"
    assert self.new_maintenance_index >= _index, "The maintenance is out of bounds"
    assert block.timestamp > _date, "The maintenance must be in the past!"

    self.maintenances[_index].service = _service
    self.maintenances[_index].repair_shop = _repair_shop
    self.maintenances[_index].date = _date
    self.maintenances[_index].mileage = _mileage

@external
@view
def get_maintenances() -> (DynArray[address, 256], DynArray[String[128], 256], DynArray[String[128], 256], DynArray[uint256, 256], DynArray[uint256, 256]):
    _registered_by: DynArray[address, 256] = []
    _service: DynArray[String[128], 256] = []
    _repair_shop: DynArray[String[128], 256] = []
    _mileage: DynArray[uint256, 256] = []
    _date: DynArray[uint256, 256] = []

    for maintenance in self.maintenances:
        _registered_by.append(maintenance.registered_by)
        _service.append(maintenance.service)
        _repair_shop.append(maintenance.repair_shop)
        _mileage.append(maintenance.mileage)
        _date.append(maintenance.date)

    return (_registered_by, _service, _repair_shop, _mileage, _date)

@external
def delete_maintenance(_index: uint256):
    self.maintenances[_index] = self.maintenances[self.new_maintenance_index]
    self.maintenances.pop()
    self.new_maintenance_index -= 1

@external
@view
def get_vehicle() -> (address, String[17], String[128]):
    return (self.owner, self.vin, self.model)

@external
def transfer_to(new_owner: address):
    assert msg.sender == self.manager, "Transfers must be made using the manager contract"
    self.owner = new_owner