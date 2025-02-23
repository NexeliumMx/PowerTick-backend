const client = require("./client");
const { DateTime } = require("luxon");
const prompt = require('prompt-sync')();

// Function to generate a random number within a specific range
function getRandom(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

async function insertMeasurements() {
  try {
    // Prompt the user for the serial number and year
    const serialNumber = prompt("Enter the serial number (e.g., DEMO0000001): ");
    const yearInput = prompt("Select year (e.g., 2024): ");

    const year = parseInt(yearInput, 10);

    // Validate the inputs
    if (!serialNumber || isNaN(year)) {
      console.error("Invalid serial number or year input.");
      return;
    }

    // Variables to accumulate consumption across the entire year
    let cumulative_real_energy_imported = 0;
    let cumulative_watt_hours_imported_phase_a = 0;
    let cumulative_watt_hours_imported_phase_b = 0;
    let cumulative_watt_hours_imported_phase_c = 0;
    let cumulative_va_hours_imported = 0;
    let cumulative_va_hours_imported_phase_a = 0;
    let cumulative_va_hours_imported_phase_b = 0;
    let cumulative_va_hours_imported_phase_c = 0;
    let cumulative_var_hours_imported_q1 = 0;
    let cumulative_var_hours_imported_q1_phase_a = 0;
    let cumulative_var_hours_imported_q1_phase_b = 0;
    let cumulative_var_hours_imported_q1_phase_c = 0;
    let cumulative_var_hours_imported_q2 = 0;
    let cumulative_var_hours_imported_q2_phase_a = 0;
    let cumulative_var_hours_imported_q2_phase_b = 0;
    let cumulative_var_hours_imported_q2_phase_c = 0;

    for (let month = 1; month <= 12; month++) {
      // Determine the number of days in the selected month and year
      const daysInMonth = DateTime.local(year, month).daysInMonth;

      // Start timestamp: first day of the month at 00:00:00 UTC-6
      let timestamp = DateTime.fromObject(
        { year: year, month: month, day: 1, hour: 0, minute: 0, second: 0 },
        { zone: "UTC-6" }
      );

      // End timestamp: last day of the month at 23:55:00 UTC-6
      const endTimestamp = DateTime.fromObject(
        { year: year, month: month, day: daysInMonth, hour: 23, minute: 55, second: 0 },
        { zone: "UTC-6" }
      );

      while (timestamp <= endTimestamp) {
        // Generate random values for each specified parameter
        const amps_phase_a = getRandom(100, 980);
        const amps_phase_b = getRandom(100, 980);
        const amps_phase_c = getRandom(100, 980);
        const amps_total = amps_phase_a + amps_phase_b + amps_phase_c;

        const phase_voltage_an = getRandom(125, 130);
        const phase_voltage_bn = getRandom(125, 130);
        const phase_voltage_cn = getRandom(125, 130);
        const frequency = getRandom(58, 63);
        const pf_phase_a = getRandom(850, 1000);
        const pf_phase_b = getRandom(850, 1000);
        const pf_phase_c = getRandom(850, 1000);

        const voltage_ln_average = Math.round(
          (phase_voltage_an + phase_voltage_bn + phase_voltage_cn) / 3
        );

        // Phase-to-phase voltage calculations using circuit rules
        const angle = 120 * (Math.PI / 180); // Convert 120 degrees to radians
        const phase_voltage_ab = Math.round(
          Math.sqrt(
            Math.pow(phase_voltage_an, 2) +
            Math.pow(phase_voltage_bn, 2) -
            2 * phase_voltage_an * phase_voltage_bn * Math.cos(angle)
          )
        );
        const phase_voltage_bc = Math.round(
          Math.sqrt(
            Math.pow(phase_voltage_bn, 2) +
            Math.pow(phase_voltage_cn, 2) -
            2 * phase_voltage_bn * phase_voltage_cn * Math.cos(angle)
          )
        );
        const phase_voltage_ca = Math.round(
          Math.sqrt(
            Math.pow(phase_voltage_cn, 2) +
            Math.pow(phase_voltage_an, 2) -
            2 * phase_voltage_cn * phase_voltage_an * Math.cos(angle)
          )
        );
        const voltage_ll_average = Math.round(
          (phase_voltage_ab + phase_voltage_bc + phase_voltage_ca) / 3
        );

        const power_factor = Math.round((pf_phase_a + pf_phase_b + pf_phase_c) / 3);
        const watts_phase_a = Math.round(
          (amps_phase_a * phase_voltage_an * (pf_phase_a / 1000)) / 1000
        );
        const watts_phase_b = Math.round(
          (amps_phase_b * phase_voltage_bn * (pf_phase_b / 1000)) / 1000
        );
        const watts_phase_c = Math.round(
          (amps_phase_c * phase_voltage_cn * (pf_phase_c / 1000)) / 1000
        );
        const total_real_power = watts_phase_a + watts_phase_b + watts_phase_c;
        const va_phase_a = Math.round((amps_phase_a * phase_voltage_an) / 1000);
        const va_phase_b = Math.round((amps_phase_b * phase_voltage_bn) / 1000);
        const va_phase_c = Math.round((amps_phase_c * phase_voltage_cn) / 1000);
        const ac_apparent_power_va = va_phase_a + va_phase_b + va_phase_c;
        const var_phase_a = Math.round(
          Math.sqrt(Math.pow(va_phase_a, 2) - Math.pow(watts_phase_a, 2))
        );
        const var_phase_b = Math.round(
          Math.sqrt(Math.pow(va_phase_b, 2) - Math.pow(watts_phase_b, 2))
        );
        const var_phase_c = Math.round(
          Math.sqrt(Math.pow(va_phase_c, 2) - Math.pow(watts_phase_c, 2))
        );
        const reactive_power_var = var_phase_a + var_phase_b + var_phase_c;

        const interval_hours = 5 / 60; // 5 minutes interval in hours
        cumulative_real_energy_imported = Math.round(cumulative_real_energy_imported + total_real_power * interval_hours);
        cumulative_watt_hours_imported_phase_a = Math.round(cumulative_watt_hours_imported_phase_a + watts_phase_a * interval_hours);
        cumulative_watt_hours_imported_phase_b = Math.round(cumulative_watt_hours_imported_phase_b + watts_phase_b * interval_hours);
        cumulative_watt_hours_imported_phase_c = Math.round(cumulative_watt_hours_imported_phase_c + watts_phase_c * interval_hours);
        cumulative_va_hours_imported = Math.round(cumulative_va_hours_imported + ac_apparent_power_va * interval_hours);
        cumulative_va_hours_imported_phase_a = Math.round(cumulative_va_hours_imported_phase_a + va_phase_a * interval_hours);
        cumulative_va_hours_imported_phase_b = Math.round(cumulative_va_hours_imported_phase_b + va_phase_b * interval_hours);
        cumulative_va_hours_imported_phase_c = Math.round(cumulative_va_hours_imported_phase_c + va_phase_c * interval_hours);
        cumulative_var_hours_imported_q1 = Math.round(cumulative_var_hours_imported_q1 + reactive_power_var * interval_hours);
        cumulative_var_hours_imported_q1_phase_a = Math.round(cumulative_var_hours_imported_q1_phase_a + var_phase_a * interval_hours);
        cumulative_var_hours_imported_q1_phase_b = Math.round(cumulative_var_hours_imported_q1_phase_b + var_phase_b * interval_hours);
        cumulative_var_hours_imported_q1_phase_c = Math.round(cumulative_var_hours_imported_q1_phase_c + var_phase_c * interval_hours);
        cumulative_var_hours_imported_q2 = Math.round(cumulative_var_hours_imported_q2 + reactive_power_var * interval_hours);
        cumulative_var_hours_imported_q2_phase_a = Math.round(cumulative_var_hours_imported_q2_phase_a + var_phase_a * interval_hours);
        cumulative_var_hours_imported_q2_phase_b = Math.round(cumulative_var_hours_imported_q2_phase_b + var_phase_b * interval_hours);
        cumulative_var_hours_imported_q2_phase_c = Math.round(cumulative_var_hours_imported_q2_phase_c + var_phase_c * interval_hours);

        const query = `
        INSERT INTO demo.measurements (
            "timestamp_utc", "timestamp_tz", amps_total, amps_phase_a, amps_phase_b, amps_phase_c,
            voltage_ln_average, phase_voltage_an, phase_voltage_bn, phase_voltage_cn,
            voltage_ll_average, phase_voltage_ab, phase_voltage_bc, phase_voltage_ca,
            frequency, total_real_power, watts_phase_a, watts_phase_b, watts_phase_c,
            ac_apparent_power_va, va_phase_a, va_phase_b, va_phase_c, reactive_power_var,
            var_phase_a, var_phase_b, var_phase_c, power_factor, pf_phase_a, pf_phase_b,
            pf_phase_c, total_real_energy_exported, total_watt_hours_exported_in_phase_a,
            total_watt_hours_exported_in_phase_b, total_watt_hours_exported_in_phase_c,
            total_real_energy_imported, total_watt_hours_imported_phase_a,
            total_watt_hours_imported_phase_b, total_watt_hours_imported_phase_c,
            total_va_hours_exported, total_va_hours_exported_phase_a,
            total_va_hours_exported_phase_b, total_va_hours_exported_phase_c,
            total_va_hours_imported, total_va_hours_imported_phase_a,
            total_va_hours_imported_phase_b, total_va_hours_imported_phase_c,
            total_var_hours_imported_q1, total_var_hours_imported_q1_phase_a,
            total_var_hours_imported_q1_phase_b, total_var_hours_imported_q1_phase_c,
            total_var_hours_imported_q2, total_var_hours_imported_q2_phase_a,
            total_var_hours_imported_q2_phase_b, total_var_hours_imported_q2_phase_c,
            total_var_hours_exported_q3, total_var_hours_exported_q3_phase_a,
            total_var_hours_exported_q3_phase_b, total_var_hours_exported_q3_phase_c,
            total_var_hours_exported_q4, total_var_hours_exported_q4_phase_a,
            total_var_hours_exported_q4_phase_b, total_var_hours_exported_q4_phase_c,
            serial_number
        ) VALUES (
            $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18,
            $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34,
            $35, $36, $37, $38, $39, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $50,
            $51, $52, $53, $54, $55, $56, $57, $58, $59, $60, $61, $62, $63, $64
        )
        `;

        const values = [
          timestamp.toISO(), // timestamp_utc
          timestamp.toISO({ includeOffset: false }), // timestamp_tz
          amps_total,
          amps_phase_a,
          amps_phase_b,
          amps_phase_c,
          voltage_ln_average,
          phase_voltage_an,
          phase_voltage_bn,
          phase_voltage_cn,
          voltage_ll_average,
          phase_voltage_ab,
          phase_voltage_bc,
          phase_voltage_ca,
          frequency,
          total_real_power,
          watts_phase_a,
          watts_phase_b,
          watts_phase_c,
          ac_apparent_power_va,
          va_phase_a,
          va_phase_b,
          va_phase_c,
          reactive_power_var,
          var_phase_a,
          var_phase_b,
          var_phase_c,
          power_factor,
          pf_phase_a,
          pf_phase_b,
          pf_phase_c,
          0, // total_real_energy_exported
          0, // total_watt_hours_exported_in_phase_a
          0, // total_watt_hours_exported_in_phase_b
          0, // total_watt_hours_exported_in_phase_c
          cumulative_real_energy_imported,
          cumulative_watt_hours_imported_phase_a,
          cumulative_watt_hours_imported_phase_b,
          cumulative_watt_hours_imported_phase_c,
          0, // total_va_hours_exported
          0, // total_va_hours_exported_phase_a
          0, // total_va_hours_exported_phase_b
          0, // total_va_hours_exported_phase_c
          cumulative_va_hours_imported,
          cumulative_va_hours_imported_phase_a,
          cumulative_va_hours_imported_phase_b,
          cumulative_va_hours_imported_phase_c,
          cumulative_var_hours_imported_q1,
          cumulative_var_hours_imported_q1_phase_a,
          cumulative_var_hours_imported_q1_phase_b,
          cumulative_var_hours_imported_q1_phase_c,
          cumulative_var_hours_imported_q2,
          cumulative_var_hours_imported_q2_phase_a,
          cumulative_var_hours_imported_q2_phase_b,
          cumulative_var_hours_imported_q2_phase_c,
          0, // total_var_hours_exported_q3
          0, // total_var_hours_exported_q3_phase_a
          0, // total_var_hours_exported_q3_phase_b
          0, // total_var_hours_exported_q3_phase_c
          0, // total_var_hours_exported_q4
          0, // total_var_hours_exported_q4_phase_a
          0, // total_var_hours_exported_q4_phase_b
          0, // total_var_hours_exported_q4_phase_c
          serialNumber
        ];

        await client.query(query, values);

        if (timestamp.minute === 0) {
          console.log("Measurement inserted successfully with timestamp:", timestamp.toISO());
        }

        timestamp = timestamp.plus({ minutes: 5 });
      }
    }

    console.log("All measurements inserted successfully!");
  } catch (error) {
    console.error("Error inserting measurements:", error);
  } finally {
    await client.end();
  }
}

insertMeasurements();