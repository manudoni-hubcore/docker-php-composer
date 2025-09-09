# docker-php-composer

Questa immagine Docker personale permette di eseguire [Composer](https://getcomposer.org/) all'interno di WSL (Windows Subsystem for Linux) senza doverlo installare direttamente nel sistema operativo. È pensata per semplificare la gestione delle dipendenze PHP in ambienti di sviluppo isolati e riproducibili.

## Caratteristiche

- Basata su Laravel Sail con Composer preinstallato
- Utente non-root configurato per evitare problemi di permessi
- Supporto per volumi persistenti (dati Composer e progetto)
- Include laravel/installer e cpx globalmente

## Build dell'immagine

```bash
docker build -t composer84:latest .
```

### Build con parametri personalizzati

Puoi personalizzare la versione di PHP e l'utente del container tramite i parametri di build:

```bash
docker build --build-arg PHP_VERSION=81 --build-arg USER_ID=$(id -u) --build-arg USER_GROUP=$(id -g) -t composer81:latest .
```

## Esecuzione del container

```bash
docker run -it --rm -u "$(id -u):$(id -g)" \
    -v composer_data:/home/docker/.composer \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html \
    composer84:latest composer [comando]
```

Esempio per installare le dipendenze:

```bash
docker run -it --rm -u "$(id -u):$(id -g)" \
    -v composer_data:/home/docker/.composer \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html \
    composer84:latest composer install
```

## Note

- Per semplificare l'uso dei comandi, puoi creare un alias nel tuo terminale:

    ```bash
    alias drun='docker run -it --rm -u "$(id -u):$(id -g)"'
    ```

    In questo modo puoi sostituire `docker run -it --rm -u "$(id -u):$(id -g)"` con `drun` in tutti gli esempi del README.

- Puoi usare questa immagine in WSL o in qualsiasi ambiente Docker compatibile.
- Il volume `composer_data` mantiene la cache e la configurazione di Composer tra le esecuzioni.
- Il volume del progetto (`$(pwd):/var/www/html`) consente di lavorare sulla directory corrente.

## Esempi di comandi utili

Mostra i pacchetti globali:

```bash
docker run -it --rm -u "$(id -u):$(id -g)" \
    -v composer_data:/home/docker/.composer \
    composer84:latest composer global show -D
```

Installa un pacchetto:

```bash
docker run -it --rm -u "$(id -u):$(id -g)" \
    -v composer_data:/home/docker/.composer \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html \
    composer84:latest composer require vendor/package
```

## Alias consigliato per Composer

Per semplificare l'utilizzo di Composer senza installarlo localmente, puoi aggiungere questo alias al tuo `.bashrc`, `.zshrc` o file di configurazione della shell:

```bash
alias composer='docker run -it --rm -u "$(id -u):$(id -g)" -v composer_data:/home/docker/.composer -v "$(pwd):/var/www/html" -w /var/www/html composer84:latest composer'
```

In questo modo potrai eseguire tutti i comandi Composer direttamente dal terminale, come se fosse installato nativamente:

```bash
composer install
composer require vendor/package
composer global show -D
```