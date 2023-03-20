# @version ^0.3.4

# Interfaces
import vehicle as Vehicle

# Structs
struct Register:
    vehicleAddress: address
    owner: address
    vin: String[17]

# State variables
vehicleTemplate: address
vehicles: DynArray[Register, 256]

@external
def __init__(template: address):
    self.vehicleTemplate = template

@external
def add_vehicle(owner: address, vin: String[17]):
    new_vehicle_address: address = create_minimal_proxy_to(self.vehicleTemplate)
    Vehicle(new_vehicle_address).setup(owner, vin)
    self.vehicles.append(Register({vehicleAddress: new_vehicle_address, owner: owner, vin: vin}))

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
def search_my_vehicles() -> DynArray[address, 256]:
    my_vehicles: DynArray[address, 256] = []

    for register in self.vehicles:
        if register.owner == msg.sender:
            my_vehicles.append(register.vehicleAddress)

    return my_vehicles