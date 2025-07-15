
function create_area_chart () {
    // Cria o container principal
    if (!document.getElementById('chart-container')) {
        const chartContainer = document.createElement('div');
        chartContainer.id = 'chart-container';
        chartContainer.className = 'chart-container';
        chartContainer.style.position = 'relative';
        chartContainer.style.height = '44vh';
        chartContainer.style.width = '40vw';
        console.log(chartContainer)
        // Cria os 4 canvases e adiciona ao container
        for (let i = 1; i <= 2; i++) {
            const canvas = document.createElement('canvas');
            canvas.id = `myChart${i}`;
            chartContainer.appendChild(canvas);
        }

        // Adiciona o container ao body (ou a outro elemento da sua página)
        mapaDiv.parentNode.appendChild(chartContainer);
        //document.body.appendChild(chartContainer);
    }
}

function destroy_charts(num_chart) {
    for (let i = 1; i <= num_chart; i++) {
        try {
            var exist_char = Chart.getChart('myChart' + i);
                exist_char.destroy();
            } catch(e) {
               console.log('chart does not exist yet to destroy');
            }
    }
    Plotly.purge('chart-container');
}

function load_curtailment(ceg, mes, ano, source, txt_title) {
    document.body.style.cursor = 'progress';  // Cursor de espera
    create_area_chart();
    //console.log(type_case)
    fetch(`/curt_data?ceg=${ceg}&mes=${mes}&ano=${ano}&source=${source}`)  // Atenção ao tipo de aspas - backticks
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
            const y = data.slice(0).map(row => row[1]);

            const ctx1 = document.getElementById('myChart1').getContext('2d', { willReadFrequently: true });
            console.log (x)
            console.log (y)
            console.log(ctx1)

            const surf_data = [{
                type: 'bar',
                x: x,
                y: y,
                marker: {
                    color: 'rgba(55,128,191,0.7)',
                    line: {
                        color: 'rgba(55,128,191,1.0)',
                        width: 2
                    }
                },

            }];
            var layout = {
                title: {
                    text: 'Curtailment: ' + ceg +': '+ source +' '+ano +'/'+ mes + '<br>' + txt_title,
                    font: { size: 12, color: 'black' }
                },
                xaxis: {
                    title: {
                        text: 'Date',
                        font: { size: 10, color: 'black' }
                    },

                    tickformat: '%d %m %Y %H:%M',  // <- Formato curto da data
                    nticks: 10,

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

            Plotly.newPlot('chart-container', surf_data, layout);

        })
         document.body.style.cursor = 'default';  // Cursor de espera
}