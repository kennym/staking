# staking

Este proyecto pretende desarrollar un contrato inteligente que actue como llave de retiro en un validador eth2.0. 

Los tokens seran vendidos a traves de una ICO y depositado en el contrato de deposito en la red prater inicialmente a traves del mismo Token cuando alcance la suma de 32 ETH.

El proyecto se basa casi en su totalidad utilizando codigo del proyecto https://github.com/OpenZeppelin/openzeppelin-contracts de la rama master para el contrato del Token y de
la rama doc-org para el contrato del crowdsale.

# Tutorial ejemplo en ubuntu

1) Hacer deploy de los smartcontracts;

	* gAsuncion --> smartcontract que maneja los tokens de participacion del pool y cuya address sera seteada como withdrawl-key del validador.
	constructor( name_, symbol_, cap_,depositContract_) el ejemplo del deposit_contract es el de la red testnet Prater en goerli.
	ejemplo : "gAsuncion","gASU",32000000000000000000,"0xff50ed3d0ec03aC01D4C79aAd74928BFF48a7b2b"
	ejemplo direccion del contrato creado : 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8
	
	* gAsuCrowdSale --> smartcontract que maneja la recaudacion de gETH, distribuye los tokens de participacion y realizara el deposito correspondiente para el validador.
	constructor (rate, wallet, token)
	ejemplo : 1,"0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8","0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8"
	ejemplo direccion del contrato creado 0xf8e81D47203A594245E36C48e151709F0C19fBe8

2) Generar las llaves del validador
	* descargar el binario de eth2deposit desde github
	https://github.com/ethereum/eth2.0-deposit-cli/releases/download/v1.2.0/eth2deposit-cli-256ea21-linux-amd64.tar.gz
	
	* generar la llave de tu validor seteando como withdrawl-key el smartcontract gAsuncion.
	./deposit new-mnemonic --eth1_withdrawal_address 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8  --num_validators 1 --chain prater --mnemonic_language english

Esto creara dos archivos dentro de la carpeta validator_keys

	>> validator_keys/deposit_data-1626894547.json
	[{"pubkey": "84f41cbc0476c886590bfd2d9bd31935e375bd753c3c92c73fe2f86f1b20e2bb7dcdad567c8ac5c93f45ca9057b6a42f", "withdrawal_credentials": "010000000000000000000000d8b934580fce35a11b58c6d73adee468a2833fa8", "amount": 
	32000000000, "signature": "a635c2c563550fad5087e2b56e561d9400d77f6e3baa3b3792cc5cf7c54074b9e08b25219029cf86832d86047de342530113835c00950f556d8f5503bf2439258df5ee7c4f765e078b9ab48a10b69c2f5b482f105497de7dce640a1879d95
	ba5", "deposit_message_root": "bd6eb4a00e34965e24034eafc5f4b2ed9e54101522047493a654dbbd21e328af", "deposit_data_root": "67ae0a94b489cef3bd49e40fb677ac38558b8abc6895c8a4b0d62c7cdb20b7a9", "fork_version": "00001020", "
	eth2_network_name": "prater", "deposit_cli_version": "1.2.0"}]
	
	>> validator_keys/keystore-m_12381_3600_2_0_0-1625620737.json
	{"crypto": {"kdf": {"function": "scrypt", "params": {"dklen": 32, "n": 262144, "r": 8, "p": 1, "salt": "44d6ddc3d8d2a7f419cd77cfb235aade5013a9a0bf1b0dd8eda31eb88fe7807a"}, "message": ""}, "checksum": {"function": "sh
	a256", "params": {}, "message": "00db3a479eb150a0c0ba5edb66c0cbd1e9a5c1112b0ffdcceb8d9ff624e48ec8"}, "cipher": {"function": "aes-128-ctr", "params": {"iv": "d0d442977bb73c984b7cea1a219b7262"}, "message": "0bac62b0164
	e50d7f1c659cc0991478b6ee4cee1ef5e0cbb4b816911733e4780"}}, "description": "", "pubkey": "85850a81923ccb1c3563b6d789bdc7def2b80315a8d8bd6415fc13443825aef31db9ccfcb65136d03af8525c0255e0f0", "path": "m/12381/3600/2/0/0",
	"uuid": "004a7a71-2240-43b9-8a9b-2aa172e9d963", "version": 4}
 
3) Setear los datos del validador en smartcontract gAsuncion.
	setValidator(pubkey_,withdrawal_credentials_,signature_,deposit_data_root_)
	0x84f41cbc0476c886590bfd2d9bd31935e375bd753c3c92c73fe2f86f1b20e2bb7dcdad567c8ac5c93f45ca9057b6a42f,0x010000000000000000000000d8b934580fce35a11b58c6d73adee468a2833fa8,0xa635c2c563550fad5087e2b56e561d9400d77f6e3baa3b3792cc5cf7c54074b9e08b25219029cf86832d86047de342530113835c00950f556d8f5503bf2439258df5ee7c4f765e078b9ab48a10b69c2f5b482f105497de7dce640a1879d95ba5,0x67ae0a94b489cef3bd49e40fb677ac38558b8abc6895c8a4b0d62c7cdb20b7a9

4) Transferir el ownership del contrato gAsuncion (0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8) al contrato gAsuCrowdSale (0xf8e81D47203A594245E36C48e151709F0C19fBe8)
	gAsuncion.transferOwnership(address)

5) Enviar gETH al gAsuCrowdSale (0xf8e81D47203A594245E36C48e151709F0C19fBe8) hasta colectar 32 gETH.
	
6) Montar un nodo ETH1 en la red goerli.
	* Instalar geth 
	
		sudo add-apt-repository -y ppa:ethereum/ethereum
		sudo apt-get update
		sudo apt-get install ethereum
	
	* Correr geth en la red de goerli
		/usr/bin/geth --goerli --http --syncmode light

7) Montar un cliente eth2.0 en la red prater.
	* descargar el binario de lighthouse desde github;
	https://github.com/sigp/lighthouse/releases/download/v1.4.0/lighthouse-v1.4.0-x86_64-unknown-linux-gnu.tar.gz
	
	* Correr el beacon node para que se syncronice con la red Beacon de Prater. Tarda como 2 dias y debe estar sincronizado antes de hacer el deposito de los 32 gETH.
		./lighthouse --network prater bn --staking
	* importar el key creado al validador.
		./lighthouse --network mainnet account validator import --directory validator_keys
	* Correr el validador en si.
		./lighthouse --network prater vc --graffiti mi_validador_es_el_mejor

8) Terminar el crowdsale. 
	gAsuCrowdSale.terminar()
	
	Pasado el periodo de espera del deposito y teniendo corriendo y sincronizados el validador/beacon-node/eth1_client nuestro validador empezara a validar bloques.

