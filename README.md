### ** SPI Master **

#### **1. Overview of the Design**
The SPI Master module in the RTL code is implemented using a **Finite State Machine (FSM)** to control essential signals such as `mosi`, `sck`, and `cs` for SPI communication. This design supports serial data transmission from the master to the slave and data reception from the slave through the following signals:

- **`mosi` (Master Out Slave In)**: Data sent from the master to the slave.
- **`miso` (Master In Slave Out)**: Data received from the slave to the master.
- **`sck` (Serial Clock)**: Clock signal used for synchronization between the master and slave.
- **`cs` (Chip Select)**: Signal to select the slave; active low (logic 0) to enable communication.

---

#### **2. FSM States**
The FSM controls the SPI master operation with the following primary states:

1. **IDLE**:
   - Waits for the start signal (`start`).
   - Keeps `cs`, `sck`, and `done` signals at their default states.

2. **START**:
   - Prepares the data to be transmitted (`data_in`) by loading it into a shift register (`shift_reg`).
   - Activates the `cs` signal (logic low) to select the slave.

3. **TRANSFER**:
   - Performs data transmission and reception.
   - Sends data bit by bit via `mosi` while receiving data from the slave through `miso`.
   - The `sck` signal provides the clock for SPI communication.

4. **DONE**:
   - Ends the communication process.
   - Deactivates the `cs` signal (logic high) and transitions the FSM back to the `IDLE` state.

---

#### **3. Key Components of the Design**
1. **Shift Register (`shift_reg`)**:
   - Stores the data to be transmitted (`data_in`).
   - Shifts left as each bit is transmitted via `mosi`.

2. **Bit Counter (`bit_cnt`)**:
   - Tracks the number of bits transmitted.
   - Ends communication when 8 bits are transmitted.

3. **SPI Clock (`sck`)**:
   - Generated from the system clock (`clk`).
   - The `sck` frequency is half the `clk` frequency.

4. **Output Data (`data_out`)**:
   - Stores the data received from the slave through `miso`.

---

#### **4. Operational Flow**
1. When the `start` signal is asserted:
   - The FSM transitions from `IDLE` to `START`.
   - The shift register (`shift_reg`) is loaded with data from `data_in`.

2. In the `TRANSFER` state:
   - The `sck` signal toggles to synchronize the data transfer.
   - On each rising edge of `sck`, one bit of data from the shift register is transmitted via `mosi`.
   - Simultaneously, data from `miso` is shifted into `data_out`.

3. Once 8 bits are transmitted:
   - The FSM moves to the `DONE` state.
   - The `cs` signal is deactivated, and the communication ends.

4. The FSM then returns to the `IDLE` state, ready for the next communication.

---

#### **5. Advantages of the Design**
- **Modularity**: The module is well-structured and reusable.
- **Synchronization**: All SPI signals are synchronized with the `sck` clock.
- **Precision**: Data is transmitted and received bit by bit with detailed state control.

---
