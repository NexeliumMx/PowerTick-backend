(async () => {
  const fetch = (await import('node-fetch')).default;

  // The URL and data to post
  const url = 'http://localhost:7071/api/demoPostAcurev-1313-5a-x0Reading';
  const data = {
      "timestamp": "2024-11-14T22:20:00.000Z",
      "serial_number": "DEMO0000005",
      "amps_total": 821,
      "amps_phase_a": 118,
      "amps_phase_b": 138,
      "amps_phase_c": 565,
      "voltage_ln_average": 129,
      "phase_voltage_an": 128,
      "phase_voltage_bn": 130,
      "phase_voltage_cn": 128,
      "voltage_ll_average": 223,
      "phase_voltage_ab": 223,
      "phase_voltage_bc": 223,
      "phase_voltage_ca": 222,
      "frequency": 60,
      "total_real_power": 99,
      "watts_phase_a": 14,
      "watts_phase_b": 16,
      "watts_phase_c": 69,
      "ac_apparent_power_va": 105,
      "va_phase_a": 15,
      "va_phase_b": 18,
      "va_phase_c": 72,
      "reactive_power_var": 34,
      "var_phase_a": 5,
      "var_phase_b": 8,
      "var_phase_c": 21,
      "power_factor": 936,
      "pf_phase_a": 939,
      "pf_phase_b": 913,
      "pf_phase_c": 955,
      "total_real_energy_exported": 0,
      "total_watt_hours_exported_in_phase_a": 0,
      "total_watt_hours_exported_in_phase_b": 0,
      "total_watt_hours_exported_in_phase_c": 0,
      "total_real_energy_imported": 63137,
      "total_watt_hours_imported_phase_a": 21098,
      "total_watt_hours_imported_phase_b": 21193,
      "total_watt_hours_imported_phase_c": 21086,
      "total_va_hours_exported": 0,
      "total_va_hours_exported_phase_a": 0,
      "total_va_hours_exported_phase_b": 0,
      "total_va_hours_exported_phase_c": 0,
      "total_va_hours_imported": 68247,
      "total_va_hours_imported_phase_a": 22804,
      "total_va_hours_imported_phase_b": 22898,
      "total_va_hours_imported_phase_c": 22789,
      "total_var_hours_imported_q1": 24164,
      "total_var_hours_imported_q1_phase_a": 8194,
      "total_var_hours_imported_q1_phase_b": 8188,
      "total_var_hours_imported_q1_phase_c": 8285,
      "total_var_hours_imported_q2": 24164,
      "total_var_hours_imported_q2_phase_a": 8194,
      "total_var_hours_imported_q2_phase_b": 8188,
      "total_var_hours_imported_q2_phase_c": 8285,
      "total_var_hours_exported_q3": 0,
      "total_var_hours_exported_q3_phase_a": 0,
      "total_var_hours_exported_q3_phase_b": 0,
      "total_var_hours_exported_q3_phase_c": 0,
      "total_var_hours_exported_q4": 0,
      "total_var_hours_exported_q4_phase_a": 0,
      "total_var_hours_exported_q4_phase_b": 0,
      "total_var_hours_exported_q4_phase_c": 0
  };

  // Function to send POST request
  async function postMeasurement() {
      try {
          const response = await fetch(url, {
              method: 'POST',
              headers: {
                  'Content-Type': 'application/json'
              },
              body: JSON.stringify(data)
          });

          if (!response.ok) {
              throw new Error(`HTTP error! Status: ${response.status}`);
          }

          const responseBody = await response.json();
          console.log("Successfully posted data:", responseBody);
      } catch (error) {
          console.error("Error posting data:", error);
      }
  }

  // Call the function to post the data
  postMeasurement();
})();
