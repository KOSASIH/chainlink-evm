// Package gethwrappers provides tools for wrapping solidity contracts with
// golang packages, using abigen.
package gethwrappers

// Make sure solidity compiler artifacts are up-to-date. Only output stdout on failure.
//go:generate ../../contracts/scripts/native_solc_compile_all

//go:generate go run ./generation/generate/wrap.go OffchainAggregator/OffchainAggregator.abi - OffchainAggregator offchain_aggregator_wrapper

// Automation
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/KeeperRegistrar1_2/KeeperRegistrar.abi ../../contracts/solc/v0.8.6/KeeperRegistrar1_2/KeeperRegistrar.bin KeeperRegistrar keeper_registrar_wrapper1_2
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/KeeperRegistrar1_2Mock/KeeperRegistrar1_2Mock.abi ../../contracts/solc/v0.8.6/KeeperRegistrar1_2Mock/KeeperRegistrar1_2Mock.bin KeeperRegistrarMock keeper_registrar_wrapper1_2_mock
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/KeeperRegistry1_2/KeeperRegistry1_2.abi ../../contracts/solc/v0.8.6/KeeperRegistry1_2/KeeperRegistry1_2.bin KeeperRegistry keeper_registry_wrapper1_2
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/KeeperRegistryCheckUpkeepGasUsageWrapper1_2Mock/KeeperRegistryCheckUpkeepGasUsageWrapper1_2Mock.abi ../../contracts/solc/v0.8.6/KeeperRegistryCheckUpkeepGasUsageWrapper1_2Mock/KeeperRegistryCheckUpkeepGasUsageWrapper1_2Mock.bin KeeperRegistryCheckUpkeepGasUsageWrapperMock gas_wrapper_mock
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/KeeperRegistry1_3/KeeperRegistry1_3.abi ../../contracts/solc/v0.8.6/KeeperRegistry1_3/KeeperRegistry1_3.bin KeeperRegistry keeper_registry_wrapper1_3
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/KeeperRegistryLogic1_3/KeeperRegistryLogic1_3.abi ../../contracts/solc/v0.8.6/KeeperRegistryLogic1_3/KeeperRegistryLogic1_3.bin KeeperRegistryLogic keeper_registry_logic1_3
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/KeeperRegistrar2_0/KeeperRegistrar2_0.abi ../../contracts/solc/v0.8.6/KeeperRegistrar2_0/KeeperRegistrar2_0.bin KeeperRegistrar keeper_registrar_wrapper2_0
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/KeeperRegistry2_0/KeeperRegistry2_0.abi ../../contracts/solc/v0.8.6/KeeperRegistry2_0/KeeperRegistry2_0.bin KeeperRegistry keeper_registry_wrapper2_0
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/KeeperRegistryLogic2_0/KeeperRegistryLogic2_0.abi ../../contracts/solc/v0.8.6/KeeperRegistryLogic2_0/KeeperRegistryLogic2_0.bin KeeperRegistryLogic keeper_registry_logic2_0
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/UpkeepTranscoder/UpkeepTranscoder.abi ../../contracts/solc/v0.8.6/UpkeepTranscoder/UpkeepTranscoder.bin UpkeepTranscoder upkeep_transcoder
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/VerifiableLoadUpkeep/VerifiableLoadUpkeep.abi ../../contracts/solc/v0.8.16/VerifiableLoadUpkeep/VerifiableLoadUpkeep.bin VerifiableLoadUpkeep verifiable_load_upkeep_wrapper
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/VerifiableLoadStreamsLookupUpkeep/VerifiableLoadStreamsLookupUpkeep.abi ../../contracts/solc/v0.8.16/VerifiableLoadStreamsLookupUpkeep/VerifiableLoadStreamsLookupUpkeep.bin VerifiableLoadStreamsLookupUpkeep verifiable_load_streams_lookup_upkeep_wrapper
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/StreamsLookupUpkeep/StreamsLookupUpkeep.abi ../../contracts/solc/v0.8.16/StreamsLookupUpkeep/StreamsLookupUpkeep.bin StreamsLookupUpkeep streams_lookup_upkeep_wrapper
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/StreamsLookupCompatibleInterface/StreamsLookupCompatibleInterface.abi ../../contracts/solc/v0.8.16/StreamsLookupCompatibleInterface/StreamsLookupCompatibleInterface.bin StreamsLookupCompatibleInterface streams_lookup_compatible_interface
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/AutomationConsumerBenchmark/AutomationConsumerBenchmark.abi ../../contracts/solc/v0.8.16/AutomationConsumerBenchmark/AutomationConsumerBenchmark.bin AutomationConsumerBenchmark automation_consumer_benchmark
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/AutomationRegistrar2_1/AutomationRegistrar2_1.abi ../../contracts/solc/v0.8.16/AutomationRegistrar2_1/AutomationRegistrar2_1.bin AutomationRegistrar automation_registrar_wrapper2_1
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/KeeperRegistry2_1/KeeperRegistry2_1.abi ../../contracts/solc/v0.8.16/KeeperRegistry2_1/KeeperRegistry2_1.bin KeeperRegistry keeper_registry_wrapper_2_1
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/KeeperRegistryLogicA2_1/KeeperRegistryLogicA2_1.abi ../../contracts/solc/v0.8.16/KeeperRegistryLogicA2_1/KeeperRegistryLogicA2_1.bin KeeperRegistryLogicA keeper_registry_logic_a_wrapper_2_1
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/KeeperRegistryLogicB2_1/KeeperRegistryLogicB2_1.abi ../../contracts/solc/v0.8.16/KeeperRegistryLogicB2_1/KeeperRegistryLogicB2_1.bin KeeperRegistryLogicB keeper_registry_logic_b_wrapper_2_1
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/IKeeperRegistryMaster/IKeeperRegistryMaster.abi ../../contracts/solc/v0.8.16/IKeeperRegistryMaster/IKeeperRegistryMaster.bin IKeeperRegistryMaster i_keeper_registry_master_wrapper_2_1
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/AutomationRegistry2_2/AutomationRegistry2_2.abi ../../contracts/solc/v0.8.19/AutomationRegistry2_2/AutomationRegistry2_2.bin AutomationRegistry automation_registry_wrapper_2_2
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/AutomationRegistryLogicA2_2/AutomationRegistryLogicA2_2.abi ../../contracts/solc/v0.8.19/AutomationRegistryLogicA2_2/AutomationRegistryLogicA2_2.bin AutomationRegistryLogicA automation_registry_logic_a_wrapper_2_2
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/AutomationRegistryLogicB2_2/AutomationRegistryLogicB2_2.abi ../../contracts/solc/v0.8.19/AutomationRegistryLogicB2_2/AutomationRegistryLogicB2_2.bin AutomationRegistryLogicB automation_registry_logic_b_wrapper_2_2
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/IAutomationRegistryMaster/IAutomationRegistryMaster.abi ../../contracts/solc/v0.8.19/IAutomationRegistryMaster/IAutomationRegistryMaster.bin IAutomationRegistryMaster i_automation_registry_master_wrapper_2_2
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/AutomationCompatibleUtils/AutomationCompatibleUtils.abi ../../contracts/solc/v0.8.19/AutomationCompatibleUtils/AutomationCompatibleUtils.bin AutomationCompatibleUtils automation_compatible_utils
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/AutomationRegistrar2_3/AutomationRegistrar2_3.abi ../../contracts/solc/v0.8.19/AutomationRegistrar2_3/AutomationRegistrar2_3.bin AutomationRegistrar automation_registrar_wrapper2_3
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/AutomationRegistry2_3/AutomationRegistry2_3.abi ../../contracts/solc/v0.8.19/AutomationRegistry2_3/AutomationRegistry2_3.bin AutomationRegistry automation_registry_wrapper_2_3
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/AutomationRegistryLogicA2_3/AutomationRegistryLogicA2_3.abi ../../contracts/solc/v0.8.19/AutomationRegistryLogicA2_3/AutomationRegistryLogicA2_3.bin AutomationRegistryLogicA automation_registry_logic_a_wrapper_2_3
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/AutomationRegistryLogicB2_3/AutomationRegistryLogicB2_3.abi ../../contracts/solc/v0.8.19/AutomationRegistryLogicB2_3/AutomationRegistryLogicB2_3.bin AutomationRegistryLogicB automation_registry_logic_b_wrapper_2_3
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/AutomationRegistryLogicC2_3/AutomationRegistryLogicC2_3.abi ../../contracts/solc/v0.8.19/AutomationRegistryLogicC2_3/AutomationRegistryLogicC2_3.bin AutomationRegistryLogicC automation_registry_logic_c_wrapper_2_3
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/IAutomationRegistryMaster2_3/IAutomationRegistryMaster2_3.abi ../../contracts/solc/v0.8.19/IAutomationRegistryMaster2_3/IAutomationRegistryMaster2_3.bin IAutomationRegistryMaster2_3 i_automation_registry_master_wrapper_2_3
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/ArbitrumModule/ArbitrumModule.abi ../../contracts/solc/v0.8.19/ArbitrumModule/ArbitrumModule.bin ArbitrumModule arbitrum_module
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/ChainModuleBase/ChainModuleBase.abi ../../contracts/solc/v0.8.19/ChainModuleBase/ChainModuleBase.bin ChainModuleBase chain_module_base
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/ScrollModule/ScrollModule.abi ../../contracts/solc/v0.8.19/ScrollModule/ScrollModule.bin ScrollModule scroll_module
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/IChainModule/IChainModule.abi ../../contracts/solc/v0.8.19/IChainModule/IChainModule.bin IChainModule i_chain_module
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/IAutomationV21PlusCommon/IAutomationV21PlusCommon.abi ../../contracts/solc/v0.8.19/IAutomationV21PlusCommon/IAutomationV21PlusCommon.bin IAutomationV21PlusCommon i_automation_v21_plus_common
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.19/MockETHUSDAggregator/MockETHUSDAggregator.abi ../../contracts/solc/v0.8.19/MockETHUSDAggregator/MockETHUSDAggregator.bin MockETHUSDAggregator mock_ethusd_aggregator_wrapper

//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/ILogAutomation/ILogAutomation.abi ../../contracts/solc/v0.8.16/ILogAutomation/ILogAutomation.bin ILogAutomation i_log_automation
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/AutomationForwarderLogic/AutomationForwarderLogic.abi ../../contracts/solc/v0.8.16/AutomationForwarderLogic/AutomationForwarderLogic.bin AutomationForwarderLogic automation_forwarder_logic
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/LogUpkeepCounter/LogUpkeepCounter.abi ../../contracts/solc/v0.8.6/LogUpkeepCounter/LogUpkeepCounter.bin LogUpkeepCounter log_upkeep_counter_wrapper
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.6/SimpleLogUpkeepCounter/SimpleLogUpkeepCounter.abi ../../contracts/solc/v0.8.6/SimpleLogUpkeepCounter/SimpleLogUpkeepCounter.bin SimpleLogUpkeepCounter simple_log_upkeep_counter_wrapper
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/LogTriggeredStreamsLookup/LogTriggeredStreamsLookup.abi ../../contracts/solc/v0.8.16/LogTriggeredStreamsLookup/LogTriggeredStreamsLookup.bin LogTriggeredStreamsLookup log_triggered_streams_lookup_wrapper
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/DummyProtocol/DummyProtocol.abi ../../contracts/solc/v0.8.16/DummyProtocol/DummyProtocol.bin DummyProtocol dummy_protocol_wrapper

//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/KeeperConsumerPerformance/KeeperConsumerPerformance.abi ../../contracts/solc/v0.8.16/KeeperConsumerPerformance/KeeperConsumerPerformance.bin KeeperConsumerPerformance keeper_consumer_performance_wrapper
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/PerformDataChecker/PerformDataChecker.abi ../../contracts/solc/v0.8.16/PerformDataChecker/PerformDataChecker.bin PerformDataChecker perform_data_checker_wrapper
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/UpkeepCounter/UpkeepCounter.abi ../../contracts/solc/v0.8.16/UpkeepCounter/UpkeepCounter.bin UpkeepCounter upkeep_counter_wrapper
//go:generate go run ./generation/generate/wrap.go ../../contracts/solc/v0.8.16/UpkeepPerformCounterRestrictive/UpkeepPerformCounterRestrictive.abi ../../contracts/solc/v0.8.16/UpkeepPerformCounterRestrictive/UpkeepPerformCounterRestrictive.bin UpkeepPerformCounterRestrictive upkeep_perform_counter_restrictive_wrapper

//go:generate go run ./generation/generate_link/wrap_link.go

//go:generate go generate go_generate_vrf.go
//go:generate go generate ./functions
//go:generate go generate ./keystone
//go:generate go generate ./llo-feeds
//go:generate go generate ./operatorforwarder
//go:generate go generate ./shared
//go:generate go generate ./ccip
//go:generate go generate ./workflow
