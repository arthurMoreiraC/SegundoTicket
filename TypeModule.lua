local module = {}
export type progressTypes = "DealDamage" | "Playtime" | "Gacha" | "Trials"

export type ProgressTable = {
	[progressTypes]: {
		Progress: number,
		MaxProgress: number,
		Completed: boolean
	}
}
export type ProgressTableData = {
	Progress: number,
	MaxProgress: number,
	Completed: boolean
}
export type template = {
	Description: string,
	Name: string,
	Class: "Daily" | "Weekly" | "Special",
	Progress: ProgressTable,
	RewardsImagesNames: {string},
}

module.progressTypes = {
	"DealDamage",
	"Playtime", 
	"Gacha",
	"Trials",
}
return module
