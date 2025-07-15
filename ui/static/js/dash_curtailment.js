function create_area_chart (ceg, dia, mes, ano, source, txt_title, typeChart) {
    const existing = document.getElementById('chart-container');
    if (existing) {
        existing.remove();  // <- Remove o container anterior e seus eventos antigos
    }
    // Cria o container principal
    if (!document.getElementById('chart-container')) {
        const chartContainer = document.createElement('div');
        chartContainer.id = 'chart-container';
        chartContainer.className = 'chart-container';
        chartContainer.style.position = 'relative';
        chartContainer.style.height = '90vh';
        chartContainer.style.width = '40vw';
        chartContainer.style.border = '1px solid #ccc';
        chartContainer.style.padding = '10px';
        //chartContainer.style.paddingTop = '25px'; // Espaço para o botão
        chartContainer.style.backgroundColor = '#f9f9f9';
        chartContainer.style.transition = 'all 0.3s ease-in-out';

        // Armazenar tamanho original
        const originalStyle = {
            position: chartContainer.style.position,
            height: chartContainer.style.height,
            width: chartContainer.style.width,
            top: chartContainer.style.top,
            left: chartContainer.style.left,
            zIndex: chartContainer.style.zIndex
        };

        // Container de filtros
        const filterContainer = document.createElement('div');
        filterContainer.style.marginBottom = '8px';
        filterContainer.style.display = 'flex';
        filterContainer.style.gap = '6px';
        filterContainer.style.alignItems = 'center';

        // Combobox de Ano
        const yearSelect = document.createElement('select');
        yearSelect.id = 'filter-year';
        yearSelect.style.fontSize = '12px';
        for (let y = 2022; y <= new Date().getFullYear(); y++) {
            const option = document.createElement('option');
            option.value = y;
            option.text = y;
            yearSelect.appendChild(option);
        }
        yearSelect.value = ano;
        filterContainer.appendChild(yearSelect);

        // Combobox de Mês
        const monthSelect = document.createElement('select');
        monthSelect.id = 'filter-month';
        monthSelect.style.fontSize = '12px';
        for (let m = 1; m <= 12; m++) {
            const option = document.createElement('option');
            option.value = m.toString().padStart(2, '0');
            option.text = m.toString().padStart(2, '0');
            monthSelect.appendChild(option);
        }
        monthSelect.value = mes;
        filterContainer.appendChild(monthSelect);

        // Combobox de Dia (opcional)
        const daySelect = document.createElement('select');
        daySelect.id = 'filter-day';
        const defaultDay = document.createElement('option');
        defaultDay.value = '';
        defaultDay.text = 'AllDays';
        daySelect.style.fontSize = '12px';
        daySelect.appendChild(defaultDay);
        for (let d = 1; d <= 31; d++) {
            const option = document.createElement('option');
            option.value = d.toString().padStart(2, '0');
            option.text = d.toString().padStart(2, '0');
            daySelect.appendChild(option);
        }
        console.log(dia)
        if (dia == null) {
            dia = ''
            console.log(dia)
        }
        daySelect.value = dia
        filterContainer.appendChild(daySelect);

        // Botão de filtro
        const filterButton = document.createElement('button');
        filterButton.textContent = 'Filtrar';
        //filterButton.style.padding = '2px 1px';
        filterButton.style.cursor = 'pointer';
        filterButton.style.fontSize = '12px';
        filterButton.style.borderRadius = '4px';
        filterButton.style.border = '1px solid #888';
        filterButton.style.backgroundColor = '#f0f0f0';
        filterButton.addEventListener('click', () => {
            const selectedYear = yearSelect.value;
            const selectedMonth = monthSelect.value;
            let selectedDay = '';

            if (daySelect.value != 'AllDays') {
                selectedDay = daySelect.value;
            } else {
                selectedDay = '';
            }
            console.log(ceg);
            // Chama a função passando os filtros
            switch (typeChart) {
                case 'Curt':
                    load_curtailment_area(ceg, selectedMonth, selectedYear, source, txt_title, selectedDay);
                    break;
                case 'Usinas':
                    load_data_usinas(ceg, selectedMonth, selectedYear, source, txt_title, selectedDay);
                    break;
            }

        });

        filterContainer.appendChild(filterButton);
        // Insere filtros no topo do container
        chartContainer.appendChild(filterContainer);


        // Container agrupando checkbox + label para melhor alinhamento
        const shapeWrapper = document.createElement('div');
        shapeWrapper.style.display = 'flex';
        shapeWrapper.style.alignItems = 'center';
        shapeWrapper.style.gap = '4px';  // Espaço entre checkbox e texto

        const shapeToggle = document.createElement('input');
        shapeToggle.type = 'checkbox';
        shapeToggle.id = 'toggle-shapes';
        shapeToggle.checked = true;
        shapeToggle.style.margin = 0;  // Remove espaçamentos indesejados

        const shapeLabel = document.createElement('label');
        shapeLabel.htmlFor = 'toggle-shapes';
        shapeLabel.textContent = 'WeekDays';
        shapeLabel.style.fontSize = '12px';
        shapeLabel.style.margin = 0;
        shapeLabel.style.lineHeight = '1';  // Alinhamento vertical

        shapeWrapper.appendChild(shapeToggle);
        shapeWrapper.appendChild(shapeLabel);
        filterContainer.appendChild(shapeWrapper);


        let isFullScreen = false;
        const chartHeights = {}; // salvar altura original de cada gráfico
        const chartWidth = {}; // salvar altura original de cada gráfico
        // Cria os gráficos e salva alturas
        for (let i = 1; i <= 2; i++) {
            const canvas = document.createElement('div');
            canvas.id = `myChart${i}`;
            canvas.style.height = '40vh';
            chartHeights[canvas.id] = canvas.style.height;
            chartWidth[canvas.id] = canvas.style.width;
            chartContainer.appendChild(canvas);
        }


        // Evento de duplo clique para expandir/recolher
        chartContainer.addEventListener('dblclick', () => {
            if (!isFullScreen) {
                chartContainer.style.position = 'fixed';
                chartContainer.style.top = '0';
                chartContainer.style.left = '0';
                chartContainer.style.width = '100vw';
                chartContainer.style.height = '100vh';
                chartContainer.style.zIndex = '9999';
                isFullScreen = true;
                // Redimensionar os gráficos para se ajustarem ao novo tamanho
                for (let i = 1; i <= 2; i++) {
                    const chart = document.getElementById(`myChart${i}`);
                    chart.style.width = '100vw';
                    chart.style.height = '48vh'; // ou ajuste conforme desejado
                    if (chart) {
                        Plotly.Plots.resize(chart);
                    }
                }

            } else {
                // Restaurar estilos originais
                chartContainer.style.position = originalStyle.position;
                chartContainer.style.height = originalStyle.height;
                chartContainer.style.width = originalStyle.width;
                chartContainer.style.top = originalStyle.top;
                chartContainer.style.left = originalStyle.left;
                chartContainer.style.zIndex = originalStyle.zIndex;

                isFullScreen = false;
                // Redimensionar os gráficos para se ajustarem ao novo tamanho
                for (let i = 1; i <= 2; i++) {
                    const chart = document.getElementById(`myChart${i}`);
                    chart.style.width = '35vw';
                    chart.style.height = chartHeights[`myChart${i}`];

                    if (chart) {
                        Plotly.Plots.resize(chart);
                    }
                }
            }


        });

        // Botão de fechar (ícone ✕)
        const closeButton = document.createElement('button');
        closeButton.innerHTML = '✕';
        closeButton.title = 'Fechar gráfico';
        closeButton.style.position = 'absolute';
        closeButton.style.top = '5px';
        closeButton.style.right = '5px';
        closeButton.style.zIndex = '1000';
        closeButton.style.cursor = 'pointer';
        closeButton.style.padding = '2px 6px';
        closeButton.style.fontSize = '16px';
        closeButton.style.border = 'none';
        closeButton.style.background = 'transparent';
        closeButton.style.color = '#333';



        // Evento para destruir os gráficos Plotly e remover container
        closeButton.addEventListener('click', () => {
            // Destroi os gráficos Plotly se existirem
            for (let i = 1; i <= 2; i++) {
                const chartId = `myChart${i}`;
                const chart = document.getElementById(chartId);
                if (chart && Plotly.purge) {
                    Plotly.purge(chart);
                }
            }

            // Remove o container do DOM
            chartContainer.remove();
            mapaDiv.style.width = '100%';
        });

        chartContainer.appendChild(closeButton);
        // Adiciona o container ao body (ou a outro elemento da sua página)
        mapaDiv.parentNode.appendChild(chartContainer);
        //document.body.appendChild(chartContainer);
    }
}


function load_curtailment_area(ceg, mes, ano, source, txt_title, dia) {
    document.body.style.cursor = 'progress';  // Cursor de espera
    //console.log('load_curtailment_area');
    //console.log(ceg);
    create_area_chart(ceg, dia, mes, ano, source, txt_title, 'Curt');
    //console.log(type_case)
    fetch(`/curt_data?ceg=${ceg}&mes=${mes}&ano=${ano}&source=${source}&dia=${dia}`)  // Atenção ao tipo de aspas - backticks
        .then(response => {
            if (!response.ok){
                alert("No Data Found!")
                throw new Error ("No Data Found!")
            }
            return response.json();
        })
        .then(data => {
            //console.log(data)
            if (data.error) {
                //console.error(data.error);
                return;
            }
            //console.log(data[0].slice(0).map(row => row[0]))

            // Separar os objetos Date e strings ISO
            const x_dates = data[0].slice(0).map(row => new Date(row[0]));
            const x = x_dates.map(date => date.toISOString()); // para Plotly
            const y1 = data[0].slice(0).map(row => row[1]);
            const y2 = data[0].slice(0).map(row => row[2]);
            //console.log (x);
            //console.log (y1);
            //console.log (y2);
            const ctx1 = document.getElementById('myChart1');

            const x_fc = data[1].slice(0).map(row => new Date(row[0]).toISOString());
            const y_fc = data[1].slice(0).map(row => row[1]);

            const ctx2 = document.getElementById('myChart2');
            //console.log (x_fc);
            //console.log (y_fc);

            // Gerar shapes para dias úteis (segunda a sexta)
            const shapes = x_dates.map(date => {
                const day = date.getUTCDay(); // 0: Domingo, 1: Segunda, ..., 6: Sábado
                if (day >= 1 && day <= 5) {  // Dias úteis
                    const isoDate = date.toISOString().split("T")[0]; // apenas yyyy-mm-dd
                    const nextDate = new Date(date);
                    nextDate.setUTCDate(date.getUTCDate() + 1);
                    return {
                        type: 'rect',
                        xref: 'x',
                        yref: 'paper',
                        x0: isoDate,
                        x1: nextDate.toISOString().split("T")[0],
                        y0: 0,
                        y1: 1,
                        fillcolor: 'rgba(240, 240, 240, 0.01)',
                        line: { width: 0 }
                    };
                }
                return null;
            }).filter(Boolean); // Remove nulos


            const fc_data = {
                type: 'scatter',
                x: x_fc,
                y: y_fc,
                name: 'Fator de Capacidade',
            };


            const trace1 = {
                fill: 'tonexty',
                fillcolor: 'rgba(170, 150, 30, 0.4)', // with 30% opacity
                type: 'scatter',
                x: x,
                y: y1,
                name: 'Generated Energy',

                marker: {
                    color: 'rgba(170, 150, 30, 0.7)',

                },
            };

            const trace2 = {
                fill: 'tonexty',
                fillcolor: 'rgba(30, 53, 201, 0.4)',
                type: 'scatter',
                x: x,
                y: y2,
                name: 'Curtailment',

                marker: {
                    color: 'rgba(30, 53, 201,0.7)',

                },

            };

            var layout = {
                title: {
                    text: 'Curtailment: ' + ceg +': '+ source +' '+ano +'/'+ mes + '<br>' + txt_title,
                    font: { size: 12, color: 'black' }
                },
                legend: {
                    orientation: 'h', // Horizontal legend
                    x: 0.5,
                    y: 1.25,
                    xanchor: 'center',
                    yanchor: 'top',
                },
                xaxis: {
                    title: {
                        text: 'Date',
                        font: { size: 10, color: 'black' }
                    },
                    type: 'date', // Explicitly set x-axis type to date
                    tickformat: '%d %m %Y %H:%M',  // <- Formato curto da data
                    nticks: 12,
                    tickfont: {
                      size: 10 // Set the font size for x-axis tick labels
                    },

                },
                yaxis: {
                    title: {
                        text: 'Power (MW)',
                        font: { size: 12, color: 'black' }
                    }
                },

                dragmode: 'zoom',
                hovermode: 'closest',
                autosize: true,
                shapes: shapes // ← adiciona os destaques dos dias úteis

            };
            var config = {
              responsive: true
            };

            var surf_data = [trace2, trace1];
            layout.transition = {
                duration: 800,
                easing: 'cubic-in-out'
            };
            // Gráfico 1 - Curtailment
            Plotly.newPlot(ctx1, surf_data, layout, config);

            // Gráfico 2 - Fator de Capacidade
            if (data[1][0] !== undefined && data[1] !== null)  {
                const nameUsina = data[1][0][2];   // nome da usinas ou do conjunto de usinas
                const layout2 = JSON.parse(JSON.stringify(layout));  // clone para evitar conflito
                layout2.title.text = 'Capacity Factor: ' + source +' '+ano +'/'+ mes + '<br>' + nameUsina;
                layout2.yaxis.title.text = 'Capacity Factor (%)';
                Plotly.newPlot(ctx2, [fc_data], layout2, config);
            }

            const shapeToggle = document.getElementById('toggle-shapes');

            // Salvar shapes para uso futuro
            let weekdayShapes = layout.shapes;

            // Controle dinâmico sem recriar o gráfico
            shapeToggle.addEventListener('change', () => {
                const show = shapeToggle.checked;
                const update = {
                    shapes: show ? weekdayShapes : []
                };
                Plotly.relayout(ctx1, update);
                Plotly.relayout(ctx2, update);
            });


        })
         document.body.style.cursor = 'default';  // Cursor de espera
}

function load_data_usinas (ceg, mes, ano, source, txt_title, dia) {
    document.body.style.cursor = 'progress';  // Cursor de espera
    create_area_chart(ceg, dia, mes, ano, source, txt_title, 'Usinas');

    fetch(`/usinas_data?ceg=${ceg}&mes=${mes}&ano=${ano}&source=${source}&dia=${dia}`)  // Atenção ao tipo de aspas - backticks
        .then(response => {
            if (!response.ok){
                alert("No Data Found!")
                throw new Error ("No Data Found!")
            }
            return response.json();
        })
        .then(data => {
            //console.log(data)
            if (data.error) {
                //console.error(data.error);
                return;
            }

            const x = data.slice(0).map(row => new Date(row[0]).toISOString());
            const y1 = data.slice(0).map(row => row[1]);

            const ctx1 = document.getElementById('myChart1');

            const usina_data = {
                type: 'scatter',
                //type: 'bar',
                x: x,
                y: y1,
                name: 'Generated Energy',
            };

            var layout = {
                title: {
                    text: 'Generated Energy: ' + ceg +': '+ source +' '+ano +'/'+ mes + '<br>' + txt_title,
                    font: { size: 12, color: 'black' }
                },
                legend: {
                    orientation: 'h', // Horizontal legend
                    x: 0.5,
                    y: 1.2,
                    xanchor: 'center',
                    yanchor: 'top',
                },
                xaxis: {
                    title: {
                        text: 'Date',
                        font: { size: 10, color: 'black' }
                    },
                    type: 'date', // Explicitly set x-axis type to date
                    tickformat: '%d %m %Y %H:%M',  // <- Formato curto da data
                    nticks: 12,
                    tickfont: {
                      size: 10 // Set the font size for x-axis tick labels
                    },

                },
                yaxis: {
                    title: {
                        text: 'Power (MW)',
                        font: { size: 12, color: 'black' }
                    }
                },

                dragmode: 'zoom',
                hovermode: 'closest',
                autosize: true,

            };
            var config = {
              responsive: true
            };

            // Gráfico 1
            Plotly.newPlot(ctx1, [usina_data], layout, config);

        })
         document.body.style.cursor = 'default';  // Cursor de espera
}