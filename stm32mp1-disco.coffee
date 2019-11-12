deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

module.exports =
	version: 1
	slug: 'stm32mp1-disco'
	aliases: [ 'stm32mp1-disco' ]
	name: 'STM32MP157A-DK1 / STM32MP157C-DK2 Discovery Boards'
	arch: 'armv7hf'
	state: 'experimental'

	instructions: commonImg.instructions
	gettingStartedLink:
		windows: ''
		osx: ''
		linux: ''
	supportsBlink: true

	options: [ networkOptions.group ]

	yocto:
		machine: 'stm32mp1-disco'
		image: 'resin-image'
		fstype: 'resinos-img'
		version: 'yocto-thud'
		deployArtifact: 'resin-image-stm32mp1-disco.resinos-img'
		compressed: true

	configuration:
		config:
			partition:
				primary: 1
			path: '/config.json'

	initialization: commonImg.initialization
