document.addEventListener("DOMContentLoaded", () => {
    const estadoEl = document.getElementById("estado");
    const anoEl = document.getElementById("ano");
    const mesEl = document.getElementById("mes");
    const diaEl = document.getElementById("dia");

    async function postJSON(url, data) {
        const response = await fetch(url, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        });
        return response.json();
    }

    function populateSelect(selectEl, values) {
        selectEl.innerHTML = "";
        values.forEach(v => {
            const option = document.createElement("option");
            option.value = v;
            option.textContent = v;
            selectEl.appendChild(option);
        });

        // Seleciona o primeiro valor por padrão, se existir
        if (values.length > 0) {
            selectEl.value = values[0];
        }
    }

    async function updateDateOptions() {
        const ano = parseInt(anoEl.value) || new Date().getFullYear();
        const data = await postJSON("/get_date_options", { ano: ano });
        populateSelect(mesEl, data.meses);
        await updateDayOptions(); // encadeia dias depois de meses
    }

    async function updateDayOptions() {
        const ano = parseInt(anoEl.value) || new Date().getFullYear();
        const mes = parseInt(mesEl.value) || 1;
        const data = await postJSON("/get_date_options", { ano: ano, mes: mes });
        populateSelect(diaEl, data.dias);
        await loadCharts(); // encadeia carregamento de gráficos
    }

    async function loadCharts() {
        const estado = estadoEl.value;
        const ano = parseInt(anoEl.value) || new Date().getFullYear();
        const mes = parseInt(mesEl.value) || 1;
        const dia = parseInt(diaEl.value) || 1;

        const payload = { estado, ano, mes, dia };

        const charts = await postJSON("/get_data", payload);

        charts.forEach((chart, i) => {
            const layout = { title: `Gráfico ${i + 1}` };
            //console.log(chart.x)
            const x_dates = chart.x.map(row => new Date(row));
            //console.log(x_dates)
            const x = x_dates.map(date => date.toISOString()); // para Plotly
            //console.log(x)
            Plotly.newPlot(`chart${i}`, [{
                x: x,
                y: chart.y,
                type: 'line'
            }], layout);
        });
    }

    // Eventos
    estadoEl.addEventListener("change", updateDateOptions);
    anoEl.addEventListener("change", updateDateOptions);
    mesEl.addEventListener("change", updateDayOptions);
    diaEl.addEventListener("change", loadCharts);

    // Inicialização com valores seguros
    updateDateOptions();
});
