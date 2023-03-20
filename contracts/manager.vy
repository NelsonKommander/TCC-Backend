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
def add_vehicle(owner: address, vin: String[17]):
    new_vehicle_address: address = create_minimal_proxy_to(self.vehicleTemplate)
    Vehicle(new_vehicle_address).setup(owner, vin)
    self.vehicles.append(Register({vehicleAddress: new_vehicle_address, owner: owner, vin: vin}))