
// preenche combo com a lista de tipos de scenarios ============================================================
const scenariosSelect = document.getElementById("scenarios");
function populateScenarios(listScenarios = ['ALL']){
    fetch('/list_scenarios')
        .then(resp => {
            if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
            return resp.json();
        })
        .then(list_scenarios => {
            //console.log(list_scenarios);
            //console.log(listScenarios);
            if (listScenarios == 'undefined') {
                listScenarios = ['ALL'];
            }
            //console.log(listScenarios);
            for(let i = 0; i < list_scenarios.length; i++){
                if (listScenarios.includes(list_scenarios[i].toUpperCase()) || listScenarios.includes('ALL')){
                    const option = document.createElement('option');
                    option.textContent = list_scenarios[i].toUpperCase();
                    option.value = list_scenarios[i];
                    scenariosSelect.appendChild(option);
                    if (i === 0) option.selected = true; // <-- seleciona primeira opção
                }
            }
            // 🚀 Dispara o evento customizado
            const event = new CustomEvent('scenariosLoaded', {
                detail: { value: scenariosSelect.value }
            });
            window.dispatchEvent(event);
        })
        .catch(err => {
            console.error('Erro ao carregar /list_scenarios:', err);
            // opcional: mostrar uma opção de erro no select
            scenariosSelect.innerHTML = '';
            const opt = document.createElement('option');
            option.textContent = 'Erro ao carregar';
            option.value = '';
            option.disabled = true;
            option.selected = true;
            scenariosSelect.appendChild(option);
        });
}
//populateScenarios();

// Preenche o Select com as distribuidoras do arquivo de configuração yml

function getDistribuidorasConfig(){
    fetch('/api/conf_dist')
        .then(response => response.json())
        .then(list_dist => {
            console.log(list_dist)
            var distSelect = document.getElementById("distribuidora");
            distSelect.innerHTML = '<option value="">Select</option>';
            list_dist.forEach(function(list_dist) {
                distSelect.innerHTML += `<option info="${list_dist[3]}" value="${list_dist[0]}">${list_dist[2]}</option>`;
            });

        })
        .catch(err => {
            console.error('Erro ao carregar distribuidoras:', err);
        });
}
getDistribuidorasConfig();

// Função para carregar subestações com base na distribuidora selecionada
document.getElementById('distribuidora').addEventListener('change', function() {
    const distribuidora = this.value;
    const circuitoSelect = document.getElementById('circuito');


    // Atualiza o link do Dashboard com o parâmetro distribuidora
    var dashboardLink = document.querySelector('a[href="/dashboard"]');
    if (dashboardLink) {
        dashboardLink.href = `/dashboard?codigoDistribuidora=${distribuidora}`;
    }

    fetch(`/api/subestacoes/${distribuidora}`)
        .then(response => response.json())
        .then(subestacoes => {
            var subestacaoSelect = document.getElementById('subestacao');
            subestacaoSelect.innerHTML = '<option value="">Select</option>';
            subestacoes.forEach(function(subestacao) {
                subestacaoSelect.innerHTML += `<option value="${subestacao[0]}">${subestacao[2]}</option>`;
            });
            circuitoSelect.innerHTML = '<option value="">Select</option>';
        })
        .catch(err => {
            console.error('Erro ao carregar subestações:', err);
        });
});

// Função para carregar circuitos com base na subestação selecionada
document.getElementById('subestacao').addEventListener('change', function() {
    var subestacao = this.value;
    var sub = subestacao.split(",");
    var circuitoSelect = document.getElementById('circuito');
    console.log(subestacao)
    if (subestacao == '') {
        circuitoSelect.innerHTML = '<option value="">Select</option>';
    } else {
        fetch(`/api/circuitos/${subestacao}`)
            .then(response => response.json())
            .then(circuitos => {
                circuitoSelect.innerHTML = '<option value="">All</option>';
                circuitos.forEach(function (circuito) {
                    circuitoSelect.innerHTML += `<option value="${circuito[1]}">${circuito[0]}</option>`;
                });
            })
            .catch(err => {
                console.error('Erro ao carregar circuitos:', err);
            });
    }
});

// Função para carregar os meses no combo de seleção de meses
const monthSelect = document.getElementById("meses");
if (monthSelect) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October',
        'November', 'December'];
    //Months are always the same
    (function populateMonths() {
        for (let i = 1; i <= months.length; i++) {
            const option = document.createElement('option');
            option.textContent = months[i - 1];
            option.value = i;
            monthSelect.appendChild(option);
        }
        monthSelect.value = "1";
    })();
    monthSelect.onchange = function () {
        //populateDays(monthSelect.value);
    }
}