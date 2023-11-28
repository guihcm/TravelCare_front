// Arquivo contendo as Cloud Functions utilizadas no Back4App


// Notificação de mudança de situação das solicitações
Parse.Cloud.afterSave('solicitacao', async (request) => {
    const original = request.original;
    const object = request.object;

    if (original && object.get('situacao') !== original.get('situacao')) {

        const Notificacao = Parse.Object.extend('notificacao');
        const notificacao = new Notificacao();

        notificacao.set('solicitacaoId', object);
        notificacao.set('pacienteId', object.get('pacienteId'));

        let situacao;
        if (object.get('situacao') == 1) situacao = "aceita";
        else if (object.get('situacao') == 2) situacao = "recusada";
        else return;

        notificacao.set('texto', 'A sua solicitação foi ' + situacao);

        try {
            await notificacao.save();
            console.log('Notificação salva com sucesso');
        } catch (error) {
            console.error('Erro ao salvar notificação: ', error);
        }
    }
});


// Notificação de boas-vindas
Parse.Cloud.afterSave(Parse.User, async (request) => {
    if (request.object.existed()) {
        return;
    }

    const Notificacao = Parse.Object.extend('notificacao');
    const notificacao = new Notificacao();

    notificacao.set('texto', 'Bem-vindo(a) ao TravelCare!');
    notificacao.set('pacienteId', request.object);

    try {
        await notificacao.save();
        console.log('Notificação de boas-vindas enviada com sucesso');
    } catch (error) {
        console.error('Erro ao enviar notificação de boas-vindas', error);
    }
});

// Cria novo acompanhante
Parse.Cloud.define("salvarAcompanhante", async (request) => {
  const { username, password, outrosCampos } = request.params;

  const user = new Parse.User();
  user.set('username', username);
  user.set('password', password);

  for (const campo in outrosCampos) {
     if (campo === 'dataNascimento') {
      const dataNascimento = new Date(outrosCampos[campo]);
      user.set(campo, dataNascimento);
    } else {
      user.set(campo, outrosCampos[campo]);
    }
  }

  user.setEmail(undefined);

  try {
    const newUser = await user.signUp(null, { useMasterKey: true });
    return { objectId: newUser.id, nomeAcompanhante: newUser.get('nomeCompleto') };

  } catch (error) {
    return { error: error.message };
  }
});



// Adicionar acompanhante na solicitação
Parse.Cloud.define("updateSolicitacaoAcompanhante", async (request) => {
    const { acompanhanteId, solicitacaoId } = request.params;

    try {
        let query = new Parse.Query('solicitacao');
        let solicitacao = await query.get(solicitacaoId, { useMasterKey: true });

        query = new Parse.Query(Parse.User);
        let acompanhante = await query.get(acompanhanteId, { useMasterKey: true });
    
        solicitacao.set('acompanhanteId', acompanhante);
    
        return solicitacao.save(null, { useMasterKey: true });
    } catch (error) {
        console.error('Erro ao adicionar acompanhante na solicitação:"' + solicitacaoId + '"', error);
        throw error; 
    }
});