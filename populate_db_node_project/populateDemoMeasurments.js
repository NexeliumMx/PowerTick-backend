const client = require("./client");
const { DateTime } = require("luxon");
const prompt = require('prompt-sync')();

// Function to generate a random number within a specific range
function getRandom(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

async function insertMeasurements() {
  try {
    // Prompt for powermeter_id, start/end year
    const powermeterIdInput = prompt("Enter the powermeter_id (integer): ");
    const startYearInput = prompt("Enter the starting year (e.g., 2023): ");
    const endYearInput = prompt("Enter the ending year (e.g., 2025): ");
    const powermeter_id = parseInt(powermeterIdInput, 10);
    const startYear = parseInt(startYearInput, 10);
    const endYear = parseInt(endYearInput, 10);
    if (isNaN(powermeter_id) || isNaN(startYear) || isNaN(endYear) || startYear > endYear) {
      console.error("Invalid powermeter_id or year input.");
      return;
    }
    // Cumulative variables
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
    for (let year = startYear; year <= endYear; year++) {
      for (let month = 1; month <= 12; month++) {
        const daysInMonth = DateTime.local(year, month).daysInMonth;
        let timestamp = DateTime.fromObject(
          { year: year, month: month, day: 1, hour: 0, minute: 0, second: 0 },
          { zone: "UTC-6" }
        );
        const endTimestamp = DateTime.fromObject(
          { year: year, month: month, day: daysInMonth, hour: 23, minute: 55, second: 0 },
          { zone: "UTC-6" }
        );
        while (timestamp <= endTimestamp) {
          // --- Electrical simulation ---
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
          const voltage_ln_average = Math.round((phase_voltage_an + phase_voltage_bn + phase_voltage_cn) / 3);
          const angle = 120 * (Math.PI / 180);
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
          const voltage_ll_average = Math.round((phase_voltage_ab + phase_voltage_bc + phase_voltage_ca) / 3);
          const power_factor = Math.round((pf_phase_a + pf_phase_b + pf_phase_c) / 3);
          const watts_phase_a = Math.round((amps_phase_a * phase_voltage_an * (pf_phase_a / 1000)) / 1000);
          const watts_phase_b = Math.round((amps_phase_b * phase_voltage_bn * (pf_phase_b / 1000)) / 1000);
          const watts_phase_c = Math.round((amps_phase_c * phase_voltage_cn * (pf_phase_c / 1000)) / 1000);
          const total_real_power = watts_phase_a + watts_phase_b + watts_phase_c;
          const va_phase_a = Math.round((amps_phase_a * phase_voltage_an) / 1000);
          const va_phase_b = Math.round((amps_phase_b * phase_voltage_bn) / 1000);
          const va_phase_c = Math.round((amps_phase_c * phase_voltage_cn) / 1000);
          const ac_apparent_power_va = va_phase_a + va_phase_b + va_phase_c;
          const var_phase_a = Math.round(Math.sqrt(Math.pow(va_phase_a, 2) - Math.pow(watts_phase_a, 2)));
          const var_phase_b = Math.round(Math.sqrt(Math.pow(va_phase_b, 2) - Math.pow(watts_phase_b, 2)));
          const var_phase_c = Math.round(Math.sqrt(Math.pow(va_phase_c, 2) - Math.pow(watts_phase_c, 2)));
          const reactive_power_var = var_phase_a + var_phase_b + var_phase_c;
          const interval_hours = 5 / 60;
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
          // --- Build measurementData with correct DB keys ---
          const measurementData = {
            powermeter_id,
            timestamp: timestamp.toISO(),
            current_total: amps_total,
            current_l1: amps_phase_a,
            current_l2: amps_phase_b,
            current_l3: amps_phase_c,
            voltage_ln: voltage_ln_average,
            voltage_l1: phase_voltage_an,
            voltage_l2: phase_voltage_bn,
            voltage_l3: phase_voltage_cn,
            voltage_ll: voltage_ll_average,
            voltage_l1_l2: phase_voltage_ab,
            voltage_l2_l3: phase_voltage_bc,
            voltage_l3_l1: phase_voltage_ca,
            frequency: frequency,
            watts: total_real_power,
            watts_l1: watts_phase_a,
            watts_l2: watts_phase_b,
            watts_l3: watts_phase_c,
            va: ac_apparent_power_va,
            va_l1: va_phase_a,
            va_l2: va_phase_b,
            va_l3: va_phase_c,
            var: reactive_power_var,
            var_l1: var_phase_a,
            var_l2: var_phase_b,
            var_l3: var_phase_c,
            power_factor: power_factor,
            pf_l1: pf_phase_a,
            pf_l2: pf_phase_b,
            pf_l3: pf_phase_c,
            kwh_imported_total: cumulative_real_energy_imported,
            kwh_imported_l1: cumulative_watt_hours_imported_phase_a,
            kwh_imported_l2: cumulative_watt_hours_imported_phase_b,
            kwh_imported_l3: cumulative_watt_hours_imported_phase_c,
            vah_imported_total: cumulative_va_hours_imported,
            vah_imported_l1: cumulative_va_hours_imported_phase_a,
            vah_imported_l2: cumulative_va_hours_imported_phase_b,
            vah_imported_l3: cumulative_va_hours_imported_phase_c,
            varh_imported_q1: cumulative_var_hours_imported_q1,
            varh_imported_q1_l1: cumulative_var_hours_imported_q1_phase_a,
            varh_imported_q1_l2: cumulative_var_hours_imported_q1_phase_b,
            varh_imported_q1_l3: cumulative_var_hours_imported_q1_phase_c,
            varh_imported_q2: cumulative_var_hours_imported_q2,
            varh_imported_q2_l1: cumulative_var_hours_imported_q2_phase_a,
            varh_imported_q2_l2: cumulative_var_hours_imported_q2_phase_b,
            varh_imported_q2_l3: cumulative_var_hours_imported_q2_phase_c
          };
          // --- Build columns and values for insert ---
          const columns = Object.keys(measurementData);
          const values = Object.values(measurementData);
          const paramPlaceholders = columns.map((_, idx) => `$${idx + 1}`);
          const query = `
            INSERT INTO demo.measurements (${columns.join(', ')})
            VALUES (${paramPlaceholders.join(', ')})
          `;
          await client.query(query, values);
          if (timestamp.minute === 0) {
            console.log("Measurement inserted with timestamp:", timestamp.toISO());
          }
          timestamp = timestamp.plus({ minutes: 5 });
        }
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