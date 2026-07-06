import type { RouteRecordRaw } from 'vue-router'

export const sortRoutesByReflectList = (
	routes: RouteRecordRaw[],
	reflectList: string[]
): RouteRecordRaw[] => {
	const extraRoutes: RouteRecordRaw[] = []
	const sortedRoutes = routes.reduce((orderedRoutes: RouteRecordRaw[], route: RouteRecordRaw) => {
		const routeIndex = reflectList.findIndex(item => item === route.meta?.title)
		if (routeIndex >= 0) {
			orderedRoutes[routeIndex] = route
		} else {
			extraRoutes.push(route)
		}
		return orderedRoutes
	}, [] as RouteRecordRaw[])

	return sortedRoutes.filter((route): route is RouteRecordRaw => Boolean(route)).concat(extraRoutes)
}
