import { describe, expect, it } from 'vitest'
import type { RouteRecordRaw } from 'vue-router'
import { sortRoutesByReflectList } from './sort'

const route = (path: string, title: string) =>
	({
		path,
		component: {},
		meta: { title },
	}) as RouteRecordRaw

describe('sortRoutesByReflectList', () => {
	it('does not leave empty entries for missing titles in the reflect list', () => {
		const sortedRoutes = sortRoutesByReflectList(
			[route('/overview', 'Overview'), route('/smtp', 'SMTP')],
			['Overview', 'Missing', 'SMTP']
		)

		expect(sortedRoutes.every(Boolean)).toBe(true)
		expect(sortedRoutes.map(route => route.path)).toEqual(['/overview', '/smtp'])
	})

	it('keeps unknown routes instead of assigning them to an invalid index', () => {
		const sortedRoutes = sortRoutesByReflectList(
			[route('/custom', 'Custom'), route('/overview', 'Overview')],
			['Overview']
		)

		expect(sortedRoutes.map(route => route.path)).toEqual(['/overview', '/custom'])
	})
})
